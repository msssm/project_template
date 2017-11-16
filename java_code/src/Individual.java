/**
 * Represents an individual.
 */
public class Individual {
    public double x;
    public double y;
    public double vx;
    public double vy;
    public boolean isParticipating;

    public Individual(double x, double y, double vx, double vy, boolean isParticipating) {
        this.x = x;
        this.y = y;
        this.vx = vx;
        this.vy = vy;
        this.isParticipating = isParticipating;
    }

    public Individual(double[] position, double[] velocity, boolean isParticipating) {
        this(position[0], position[1], velocity[0], velocity[1], isParticipating);
    }

    public double[] getPosition() {
        return new double[] {x, y};
    }

    public double[] getVelocity() {
        return new double[] {vx, vy};
    }

    public double distanceTo(Individual other) {
        double dx = Math.abs(x - other.x);
        double dy = Math.abs(y - other.y);

        return Math.sqrt(dx * dx + dy * dy);
    }
}
