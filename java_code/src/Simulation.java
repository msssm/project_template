
public class Simulation {

    public final double epsilon;
    public final double mu;
    public final double alpha;
    public final double numberOfPeople;

    public PositionMatrix matrix;

    public Simulation(double epsilon, double mu, double alpha, double numberOfPeople) {
        this.epsilon = epsilon;
        this.mu = mu;
        this.alpha = alpha;
        this.numberOfPeople = numberOfPeople;
        initializeMatrix();
    }

    private void initializeMatrix() {
        // TODO: Calculate optimal matrix size and sector size
        // for now: create some bogus values
        int tempMatrixSize = 2;
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
        // TODO: implement runSimulation
    }

    private void runOneTimestep() {
        // TODO: implement runOneTimestep
    }
}
