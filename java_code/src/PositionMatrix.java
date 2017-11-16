import java.util.LinkedList;

public class PositionMatrix {

    private LinkedList<Individual>[][] matrix;
    public int width;
    public int height;
    public int sectorSize;

    public class Sector {
        int row;
        int col;
        public Sector(int row, int col) {
            this.row = row;
            this.col = col;
        }
    }

    public PositionMatrix(int width, int height, int sectorSize) {
        this.height = height;
        this.width = width;
        this.sectorSize = sectorSize;
        matrix = (LinkedList<Individual>[][]) new LinkedList[width][height];
        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                matrix[i][j] = new LinkedList<Individual>();
            }
        }
    }

    public LinkedList<Individual> get(int i, int j) {
        return matrix[i][j];
    }

    public LinkedList<Individual> get(Sector sector) {
        return matrix[sector.row][sector.col];
    }

    public void add(Individual individual) {
        Sector sector = getSectorForCoords(individual);
        matrix[sector.row][sector.col].add(individual);
    }

    public LinkedList<Individual> getNeighborsFor(Individual individual) {
        // TODO
        return null;
    }

    public Sector getSectorForCoords(double x, double y) {
        int sectorX = (int) x / sectorSize;
        int sectorY = (int) y / sectorSize;

        if (sectorX < 0) sectorX = 0;
        else if (sectorX >= width) sectorX = width -1;

        if (sectorY < 0) sectorY = 0;
        else if (sectorY >= height) sectorY = height - 1;

        return new Sector(sectorX, sectorY);
    }

    public Sector getSectorForCoords(Individual individual) {
        return getSectorForCoords(individual.x, individual.y);
    }

    public Sector getSectorForCoords(double[] position) {
        return getSectorForCoords(position[0], position[1]);
    }
}
