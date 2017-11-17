import java.util.List;

public class Simulation {

    public final double epsilon;
    public final double mu;
    public final double alpha;
    public final double numberOfPeople;
    public final double flockRadius;
    public final double individualRadius;
    public final double dt;

    public PositionMatrix matrix;

    public Simulation(double epsilon, double mu, double alpha, double numberOfPeople, double flockRadius, double individualRadius, double dt) {
        this.epsilon = epsilon;
        this.mu = mu;
        this.alpha = alpha;
        this.numberOfPeople = numberOfPeople;
        this.flockRadius = flockRadius;
        this.individualRadius = individualRadius;
        this.dt = dt;
        initializeMatrix();
    }

    private void initializeMatrix() {
        // TODO: Calculate optimal matrix size and sector size
        // for now: create some bogus values
        int tempMatrixSize = 10;
        int tempSectorSize = 10;

        matrix = new PositionMatrix(tempMatrixSize, tempMatrixSize, tempSectorSize);

        for (int i = 0; i < numberOfPeople; i++) {
            // Generate random coordinates
            double[] coords = new double[2];
            coords[0] = Math.random() * tempSectorSize * tempMatrixSize;
            coords[1] = Math.random() * tempSectorSize * tempMatrixSize;

            // Generate random velocity
            // TODO: Generate more sensible velocity
            double[] velocity = new double[] {Math.random() - 0.5, Math.random() - 0.5};

            // TODO: Decide whether individual is participating
            boolean isParticipating = false;

            Individual individual = new Individual(coords, velocity, isParticipating);

            // Add individual to appropriate sector
            matrix.add(individual);
        }
    }

    public void runSimulation() {
        // TODO: Implement runSimulation
    }

    /*private*/ void runOneTimestep() {

        List<Individual> individuals = matrix.getIndividuals();

        for (Individual individual : individuals) {
            double[] F = {0.0, 0.0};
            double[] sumOverVelocities = {0.0, 0.0};
            List<Individual> neighbors = matrix.getNeighborsFor(individual, flockRadius);
            double[] position = individual.getPosition();
            double[] velocity = individual.getVelocity();
            double r0 = individualRadius;

            // =========================== CALCULATION OF THE FORCES =================================
            for (Individual neighbor : neighbors) {
                double[] positionNeighbor = neighbor.getPosition();
                double[] velocityNeighbor = neighbor.getVelocity();

                double distance = individual.distanceTo(neighbor);

                // Repulsive force
                // We only use neighbors within a radius of 2 * r0
                if (distance < 2 * r0) {
                    F[0] += epsilon * Math.pow((1 - distance / (2*r0)), 5/2) * (position[0] - positionNeighbor[0]) / distance;
                    F[1] += epsilon * Math.pow((1 - distance / (2*r0)), 5/2) * (position[1] - positionNeighbor[1]) / distance;
                }

                sumOverVelocities[0] += velocityNeighbor[0];
                sumOverVelocities[1] += velocityNeighbor[1];
            }

            // Propulsion
            // TODO: v0 is the "preferred speed", vi is the "instantaneous speed"

            // Flocking
            if (!(sumOverVelocities[0] == 0 && sumOverVelocities[1] == 0)) {
                double norm = norm(sumOverVelocities);
                F[0] += alpha * sumOverVelocities[0] / norm;
                F[1] += alpha * sumOverVelocities[1] / norm;
            }

            // Add noise
            // TODO: Generate noise

            // ======================= CALCULATE TIMESTEP ========================
            // Using the leap-frog method to integrate the differential equation d^2y/dt^2 = rhs(y)

            // Shifted initial velocity for leap-frog
            double[] v_temp = new double[2];
            v_temp[0] = velocity[0] + 0.5 * dt * F[0];
            v_temp[1] = velocity[1] + 0.5 * dt * F[1];

            individual.x = position[0] + dt * v_temp[0];
            individual.y = position[1] + dt * v_temp[1];

            individual.vx = v_temp[0] + dt * F[0] / 2;
            individual.vy = v_temp[1] + dt * F[1] / 2;
        }
    }

    private double norm(double[] vector) {
        return Math.sqrt(vector[0] * vector[0] + vector[1] * vector[1]);
    }
}
