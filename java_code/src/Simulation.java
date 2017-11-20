import javax.swing.*;
import javax.swing.Timer;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

public class Simulation {

    public final double epsilon;
    public final double mu;
    public final double alpha;
    public final double numberOfPeople;
    public final double flockRadius;
    public final double dt;

    private double maxX;
    private double maxY;

    public PositionMatrix matrix;

    public Simulation(double epsilon, double mu, double alpha, double numberOfPeople, double flockRadius, double dt) {
        this.epsilon = epsilon;
        this.mu = mu;
        this.alpha = alpha;
        this.numberOfPeople = numberOfPeople;
        this.flockRadius = flockRadius;
        this.dt = dt;
        initializeMatrix();
    }

    private void initializeMatrix() {
        // TODO: Calculate optimal matrix size and sector size
        // for now: create some bogus values
        int tempMatrixSize = 10;
        int tempSectorSize = 10;

        // The maximum x and y values that an individual can have
        maxX = tempMatrixSize * tempSectorSize;
        maxY = tempMatrixSize * tempSectorSize;

        matrix = new PositionMatrix(tempMatrixSize, tempMatrixSize, tempSectorSize);

        for (int i = 0; i < numberOfPeople; i++) {
            // Generate random coordinates
            double[] coords = new double[2];
            coords[0] = Math.random() * tempSectorSize * tempMatrixSize;
            coords[1] = Math.random() * tempSectorSize * tempMatrixSize;

            // Generate random velocity
            // TODO: Generate more sensible velocity
            double[] velocity = new double[] {Math.random() - 0.5, Math.random() - 0.5};
//            double[] velocity = new double[] {1, 1};

            // TODO: Decide whether individual is participating
            boolean isParticipating = false;

            Individual individual = new Individual(coords, velocity, isParticipating);

            // Add individual to appropriate sector
            matrix.add(individual);
        }
    }

    public void runSimulation() {
        // TODO: Implement runSimulation properly

        // Create a window for the simulation
        JFrame window = new JFrame("Moshpit Simulation");
        window.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        window.setLayout(new BorderLayout());
        SimulationPanel panel = new SimulationPanel(500, 500, matrix.getIndividuals(), matrix.width * matrix.sectorSize, matrix.height * matrix.sectorSize);
        window.add(panel, BorderLayout.CENTER);
        window.pack();

        // Run a new frame every 50 milliseconds
        new Timer(50, new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                runOneTimestep();
                panel.repaint();
            }
        }).start();

        window.setVisible(true);
    }

    /*private*/ void runOneTimestep() {

        // List of al the individuals in the matrix
        List<Individual> individuals = matrix.getIndividuals();

        // Iterate over each individual
        for (Individual individual : individuals) {
            // Sector where the individual is before updating position
            PositionMatrix.Sector initialSector = matrix.getSectorForCoords(individual);
            // Forces acting upon individual
            double[] F = {0.0, 0.0};
            // Sum of the neighbor velocities
            double[] sumOverVelocities = {0.0, 0.0};
            // List of neighbors
            List<Individual> neighbors = matrix.getNeighborsFor(individual, flockRadius);
            // Position and velocity of individual
            double[] position = individual.getPosition();
            double[] velocity = individual.getVelocity();
            double r0 = individual.radius;

            // =========================== CALCULATION OF THE FORCES =================================
            for (Individual neighbor : neighbors) {
                // Make sure we are not using the individual him/herself
                if (neighbor == individual) {
                    continue;
                }
                double[] positionNeighbor = neighbor.getPosition();
                double[] velocityNeighbor = neighbor.getVelocity();

                double distance = individual.distanceTo(neighbor);

                // Repulsive force
                // We only use neighbors within a radius of 2 * r0
                if (distance < 2 * r0) {
                    F[0] += epsilon * Math.pow((1 - distance / (2 * r0)), 5 / 2) * (position[0] - positionNeighbor[0]) / distance;
                    F[1] += epsilon * Math.pow((1 - distance / (2 * r0)), 5 / 2) * (position[1] - positionNeighbor[1]) / distance;
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

            // New position of the individual
            double newX = position[0] + dt * v_temp[0];
            double newY = position[1] + dt * v_temp[1];

            // New velocity of the individual
            double newVx = v_temp[0] + dt * F[0] / 2;
            double newVy = v_temp[1] + dt * F[1] / 2;
            double[] newV = {newVx, newVy};
            // Normalize velocity
            newVx /= norm(newV);
            newVy /= norm(newV);
            newVx *= 30;
            newVy *= 30;

            // Make sure individuals rebound off the edges of the space
            if (newX < 0 || newX > maxX) {
                newVx = -newVx;
                F[0] = -F[0];
            }
            if (newY < 0 || newY > maxY) {
                newVy = -newVy;
                F[1] = -F[1];
            }

            // Make sure they don't get stuck in an out-of-bounds area
            if (newX >= 0 && newX <= maxX)
                individual.x = newX;
            if (newY >= 0 && newY <= maxY)
                individual.y = newY;

            individual.vx = newVx;
            individual.vy = newVy;

            // Add the individual to the correct sector
            PositionMatrix.Sector newSector = matrix.getSectorForCoords(individual);
            if (!newSector.equals(initialSector)) {
                matrix.removeAndAdd(individual, initialSector, newSector);
            }
        }
    }

    private double norm(double[] vector) {
        return Math.sqrt(vector[0] * vector[0] + vector[1] * vector[1]);
    }
}
