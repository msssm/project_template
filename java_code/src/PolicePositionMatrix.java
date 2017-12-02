public class PolicePositionMatrix extends PositionMatrix {

    public boolean[][] isPoliceAtSector;

    /**
     * Creates a new PolicePositionMatrix
     *
     * @param width      The desired width of the matrix
     * @param height     The desired height of the matrix
     * @param sectorSize The desired sector size
     */
    public PolicePositionMatrix(int width, int height, int sectorSize) {
        super(width, height, sectorSize);
        isPoliceAtSector = new boolean[width][height];
    }

    public boolean isSectorMonitored(Sector sector) {
        return isPoliceAtSector[sector.row][sector.col];
    }

    public void setMonitoredSectors(int... policeSectors) {
        for (int i = 0; i < policeSectors.length; i += 2) {
            isPoliceAtSector[policeSectors[i]][policeSectors[i+1]] = true;
        }
    }

}
