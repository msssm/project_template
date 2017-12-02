/**
 * Represents an individual.
 */
public class Individual {
    public double x;
    public double y;
    public double vx;
    public double vy;
    public boolean isParticipating;
    public double radius = 2;
    public double preferredSpeed = 30;
    public int dangerLevel;
    public double f;
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

    public double distanceTo(double[] point) {
        double dx = Math.abs(x - point[0]);
        double dy = Math.abs(y - point[1]);

        return Math.sqrt(dx * dx + dy * dy);
    }

    public double[] getCenter() {
        return new double[] {x + radius / 2, y + radius / 2};
    }

    @Override
    public String toString() {
        return "Individual: position = (" + x + ", " + y + "), velocity = (" + vx + ", " + vy + "), isParticipating = " + isParticipating;
    }
}
