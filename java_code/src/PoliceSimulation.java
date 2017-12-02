
public class PoliceSimulation extends Simulation {

    public PoliceSimulation(double epsilon, double mu, double alpha, double gamma, double numberOfPeople, double flockRadius, double dt, double percentParticipating, double rParticipating, int minCirclePitSize, int minParticipatingNeighbors) {
        this.epsilon = epsilon;
        this.mu = mu;
        this.alpha = alpha;
        this.gamma = gamma;
        this.numberOfPeople = numberOfPeople;
        this.flockRadius = flockRadius;
        this.dt = dt;
        this.percentParticipating = percentParticipating;
        this.rParticipating = rParticipating;
        this.minCirclePitSize = minCirclePitSize;
        this.minParticipatingNeighbors = minParticipatingNeighbors;
        initializeMatrix(1);
    }

    @Override
    public void performAdditionalCalculations(Individual individual) {
        PolicePositionMatrix matrix = (PolicePositionMatrix) getMatrix();
        if (matrix.isSectorMonitored(matrix.getSectorForCoords(individual))) {
            individual.isParticipating = false;
        }
    }

    public void setMonitoredSectors(int... sectors) {
        ((PolicePositionMatrix) getMatrix()).setMonitoredSectors(sectors);
    }
}
