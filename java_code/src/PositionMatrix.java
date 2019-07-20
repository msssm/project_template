import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 * Data structure representing the position matrix in the simulation.
 */
public class PositionMatrix {

    /**
     * The width of the matrix
     */
    public final int width;
    /**
     * The height of the matrix
     */
    public final int height;
    /**
     * The size of one sector
     */
    public final int sectorSize;
    /**
     * A boolean matrix to indicate whether sector (i, j) is under police
     * surveillance
     */
    public boolean[][] isPoliceAtSector;
    // The actual matrix
    private LinkedList<Individual>[][] matrix;
    // A List containing all the individuals, makes iterating over them easier
    private ArrayList<Individual> individuals;

    /**
     * Creates a new PositionMatrix
     *
     * @param width      The desired width of the matrix
     * @param height     The desired height of the matrix
     * @param sectorSize The desired sector size
     */
    public PositionMatrix(int width, int height, int sectorSize) {
        this.height = height;
        this.width = width;
        this.sectorSize = sectorSize;

        // Initialize the matrix
        matrix = (LinkedList<Individual>[][]) new LinkedList[width][height];
        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                matrix[i][j] = new LinkedList<Individual>();
            }
        }

        individuals = new ArrayList<Individual>();
        isPoliceAtSector = new boolean[width][height];
    }

    /**
     * Gets an individual at position (i, j) in the matrix.
     *
     * @param i The row of the individual
     * @param j The column of the individual
     * @return The individual at (i, j)
     */
    public List<Individual> get(int i, int j) {
        return matrix[i][j];
    }

    /**
     * Gets an individual at the specified sector in the matrix.
     *
     * @param sector The sector that the individual is in.
     * @return The individual at the given sector.
     */
    public List<Individual> get(Sector sector) {
        return matrix[sector.row][sector.col];
    }

    /**
     * Gets a list of all the individuals.
     *
     * @return The list of the individuals.
     */
    public List<Individual> getIndividuals() {
        return individuals;
    }

    /**
     * Adds a new individual to the matrix at the proper position.
     *
     * @param individual The individual to be added
     */
    public void add(Individual individual) {
        Sector sector = getSectorForCoords(individual);
        matrix[sector.row][sector.col].add(individual);
        individuals.add(individual);
    }

    public void removeAndAdd(Individual individual, Sector oldSector,
                             Sector newSector) {
        matrix[oldSector.row][oldSector.col].remove(individual);
        matrix[newSector.row][newSector.col].add(individual);
    }

    /**
     * Gets the neighbors of an individual.
     *
     * @param individual The individual for whom to search for neighbors
     * @param radius     The radius in which to search
     * @return A <code>java.util.List</code> of the neighbors.
     */
    public List<Individual> getNeighborsFor(Individual individual,
                                            double radius) {
        ArrayList<Individual> neighbors = new ArrayList<Individual>(10);
        ArrayList<Sector> sectorsToSearch = new ArrayList<Sector>(9);
        Sector sector = getSectorForCoords(individual);
        sectorsToSearch.add(sector);

        // Look around the current sector
        for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
                Sector newSector = getSectorForCoords(individual.x + i * radius,
                                                      individual.y +
                                                              i * radius);
                if (!sector.equals(newSector)) {
                    sectorsToSearch.add(newSector);
                }
            }
        }

        // Look for neighbors at the appropriate distance in the sectors to
        // search
        for (Sector sectorToSearch : sectorsToSearch) {
            List<Individual> possibleNeighbors = get(sectorToSearch);
            for (Individual neighbor : possibleNeighbors) {
                if (individual.distanceTo(neighbor) < radius) {
                    neighbors.add(neighbor);
                }
            }
        }

        return neighbors;
    }

    /**
     * Gets the sector for the given coordinates.
     *
     * @param x The x coordinate
     * @param y The y coordinate
     * @return A <code>Sector</code> object corresponding the the given
     * coordinates.
     */
    public Sector getSectorForCoords(double x, double y) {
        int sectorX = (int) x / sectorSize;
        int sectorY = (int) y / sectorSize;

        // Make sure the sector is not out of bounds
        if (sectorX < 0) sectorX = 0;
        else if (sectorX >= width) sectorX = width - 1;

        if (sectorY < 0) sectorY = 0;
        else if (sectorY >= height) sectorY = height - 1;

        return new Sector(sectorX, sectorY);
    }

    /**
     * Gets the sector that the given individual is in.
     *
     * @param individual The individual for whom to get the sector
     * @return The sector that the individual is in.
     * @see PositionMatrix#getSectorForCoords(double, double)
     */
    public Sector getSectorForCoords(Individual individual) {
        return getSectorForCoords(individual.x, individual.y);
    }

    /**
     * Gets the sector that the given individual is in given an array of {x, y}
     * coordinates.
     *
     * @param position The array of coordinates
     * @return The sector corresponding to <code>position</code>
     * @see PositionMatrix#getSectorForCoords(double, double)
     */
    public Sector getSectorForCoords(double[] position) {
        return getSectorForCoords(position[0], position[1]);
    }

    /**
     * Checks if the given sector is monitored by the police.
     */
    public boolean isSectorMonitored(Sector sector) {
        return isPoliceAtSector[sector.row][sector.col];
    }

    /**
     * Adds the given list of sectors to be monitored by the police.
     *
     * @param policeSectors A comma separated list of sectors, e.g. 0, 0, 1, 1,
     *                      2, 2
     */
    public void setMonitoredSectors(int... policeSectors) {
        for (int i = 0; i < policeSectors.length; i += 2) {
            isPoliceAtSector[policeSectors[i]][policeSectors[i + 1]] = true;
        }
    }

    /**
     * An inner class that represents one sector at a particular location in the
     * matrix.
     */
    public class Sector {
        int row;  // Row of the matrix
        int col;  // Column of the matrix

        public Sector(int row, int col) {
            this.row = row;
            this.col = col;
        }

        public boolean equals(Sector other) {
            return row == other.row && col == other.col;
        }
    }
}
