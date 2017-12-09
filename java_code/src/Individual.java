/**
 * Represents an individual.
 */
public class Individual {
    /**
     * The x position of this individual.
     */
    public double x;
    /**
     * The y position of this individual.
     */
    public double y;
    /**
     * The x velocity of this individual.
     */
    public double vx;
    /**
     * The y velocity of this individual.
     */
    public double vy;
    /**
     * True if the individual is participating in the circle pit.
     */
    public boolean isParticipating;
    /**
     * The size of the individual.
     */
    public double radius = 2;
    /**
     * The preferred speed of the individual.
     */
    public double preferredSpeed = 30;
    /**
     * The danger level that the individual is currently at. Ranges from 0 to 6.
     */
    public int dangerLevel;
    /**
     * The norm of the force currently acting on the individual.
     */
    public double f;
    /**
     * Number of neighbors of the individual.
     */
    public double density;

    public Individual(double x, double y, double vx, double vy, boolean isParticipating, int dangerLevel) {
        this.x = x;
        this.y = y;
        this.vx = vx;
        this.vy = vy;
        this.isParticipating = isParticipating;
        this.dangerLevel = dangerLevel;
    }

    public Individual(double[] position, double[] velocity, boolean isParticipating, int dangerLevel) {
        this(position[0], position[1], velocity[0], velocity[1], isParticipating, dangerLevel);
    }

    public double[] getPosition() {
        return new double[]{x, y};
    }

    public double[] getVelocity() {
        return new double[]{vx, vy};
    }

    public double distanceTo(Individual other) {
        double dx = Math.abs(x - other.x);
        double dy = Math.abs(y - other.y);

        return Math.sqrt(dx * dx + dy * dy);
    }

    public double distanceTo(double[] point) {
        double dx = Math.abs(x - point[0]);
        double dy = Math.abs(y - point[1]);

        return Math.sqrt(dx * dx + dy * dy);
    }

    @Override
    public String toString() {
        return "Individual: position = (" + x + ", " + y + "), velocity = (" + vx + ", " + vy + "), isParticipating = " + isParticipating;
    }
}
