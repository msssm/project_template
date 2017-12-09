import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.List;

/**
 * Class that automatically runs the simulation for one police configuration and harvests data from it.
 */
public class DataCollector implements ActionListener {

    private Simulation simulation;  // Simulation for which to collect data

    private PrintWriter fileCounterWriter;  // Writes number of timepoints and number of seeds
    private PrintWriter outWriter;  // Writes data
    private int seedCounter = 0;  // Counts how many seeds have already been tested
    private int timeCounter = 0;  // Counts how many timepoints we have already dumped data for
    private final int MAX_TIME;  // Max amount of timepoints to dump data for
    private final int MAX_SEEDS;  // Max amount of seeds to test
    private final int timeStepInterval;  // Refresh rate of simulation
    private int realTimeElapsed = 0;  // Amount of timesteps of the simulation elapsed
    private final int dataCollectionInterval;  // How often to collect data
    private int insertPoliceAfterCounter = 0;  // Counter to test if we should insert police
    private boolean stillWaitingToInsertPolice = true;  // True if police not inserted yet
    private int insertPoliceAfter;  // How many timesteps to wait before inserting police

    public boolean hasInsertedPolice = false;  // True if police inserted
    private boolean[][] policeSectors = new boolean[10][10];  // Sectors with police

    private String configurationName;  // Name of the configuration we are currently testing

    public DataCollector(Simulation simulation, String configurationName, int timeStepInterval, int dataCollectionInterval, int insertPoliceAfter, int maxSeeds, int maxTime, boolean[][] policeSectors) {
        this.simulation = simulation;
        this.timeStepInterval = timeStepInterval;
        this.dataCollectionInterval = dataCollectionInterval;
        this.insertPoliceAfter = insertPoliceAfter;
        this.policeSectors = policeSectors;
        MAX_TIME = maxTime;
        MAX_SEEDS = maxSeeds;
        // Files are named as out_[seed#]_[time#].py in a subfolder for this configuration
        File file = new File(configurationName + "/out_0_0.py");
        file.getParentFile().mkdirs();
        try {
            fileCounterWriter = new PrintWriter(configurationName + "/counter.py");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        try {
            outWriter = new PrintWriter(configurationName + "/out_0_0.py", "UTF-8");
        } catch (FileNotFoundException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        this.configurationName = configurationName;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        PositionMatrix matrix = simulation.getMatrix();
        realTimeElapsed += timeStepInterval;  // Check how much time has elapsed to see if we should dump data
        if (!simulation.isCurrentIterationFinished) {
            simulation.runOneTimestep();
            simulation.repaint();
            if (stillWaitingToInsertPolice) {
                insertPoliceAfterCounter++;
            }
            if (insertPoliceAfterCounter >= insertPoliceAfter) {  // Check if the appropriate amount of time before inserting police has elapsed
                stillWaitingToInsertPolice = false;
            }
            if (!stillWaitingToInsertPolice && !hasInsertedPolice) {  // Insert the police
                simulation.setMonitoredSectors(policeSectors);
                this.hasInsertedPolice = true;
            }
        }
        // Dump data if now is the right time
        if (realTimeElapsed % dataCollectionInterval == 0 && !simulation.isCurrentIterationFinished) {
            realTimeElapsed = 0;

            outWriter.println("from numpy import *");
            outWriter.flush();

            List<Individual> individuals = matrix.getIndividuals();

            writeNumPyArray(individuals, "x", outWriter, "x");
            writeNumPyArray(individuals, "y", outWriter, "y");
            writeNumPyArray(individuals, "dangerLevel", outWriter, "dangerLevel");
            writeIsParticipatingData(matrix);
            writeNumPyArray(individuals, "f", outWriter, "F");
            writeNumPyArray(individuals, "density", outWriter, "density");
            writeAverageDanger(matrix);
            writeMaxDanger(matrix);

            // If we have dumped data enough times, restart with a new seed
            if (timeCounter >= MAX_TIME) {
                timeCounter = 0;
                simulation.setSeed(seedCounter);
                seedCounter++;
                simulation.restartSimulation();
                hasInsertedPolice = false;
                stillWaitingToInsertPolice = true;
                insertPoliceAfterCounter = 0;
            }
            // If we have tested enough seeds, finish the simulation
            if (seedCounter >= MAX_SEEDS) {
                fileCounterWriter.println("n = " + MAX_TIME);
                fileCounterWriter.println("m = " + MAX_SEEDS);
                fileCounterWriter.flush();
                fileCounterWriter.close();
                outWriter.flush();
                outWriter.close();
                simulation.isCurrentIterationFinished = true;
            } else {
                resetWriters(configurationName + "/out_" + seedCounter + "_" + timeCounter + ".py");
                timeCounter++;
            }
        }
    }

    // Writes 1 to a numpy array if individual is participating, else 0
    private void writeIsParticipatingData(PositionMatrix matrix) {
        outWriter.print("isParticipating = array([");
        boolean firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) outWriter.print((individual.isParticipating ? 1 : 0));
            else outWriter.print(", " + (individual.isParticipating ? 1 : 0));
            firstTime = false;
        }
        outWriter.println("])");
        outWriter.flush();
    }

    // Writes the average danger of all the individuals
    private void writeAverageDanger(PositionMatrix matrix) {
        outWriter.print("averageDanger = ");
        double averageDanger = 0;
        for (Individual individual : matrix.getIndividuals()) {
            averageDanger += individual.f / 10000 + individual.density / 50;
        }
        averageDanger /= matrix.getIndividuals().size();
        outWriter.println(averageDanger);
        outWriter.flush();
    }

    // Writes the max danger of all the individuals
    private void writeMaxDanger(PositionMatrix matrix) {
        outWriter.print("maxDanger = ");
        double maxDanger = -1;
        for (Individual individual : matrix.getIndividuals()) {
            maxDanger += Math.max(maxDanger, individual.f / 10000 + individual.density / 50);
        }
        outWriter.println(maxDanger);
        outWriter.flush();
    }

    // Make sure we are writing to the appropriate file
    private void resetWriters(String newOutFileName) {
        try {
            outWriter.close();
            outWriter = new PrintWriter(newOutFileName, "UTF-8");
        } catch (FileNotFoundException | UnsupportedEncodingException e3) {
            e3.printStackTrace();
        }
    }

    /**
     * Iterates over the given list and, for each element of that list, adds the value of the field with the given name
     * to a numpy array that is written to a file using the provided PrintWriter. The resulting array is named
     * <code>description</code>.
     * @param list The list from which to gather the data
     * @param propertyName The property that we want to output
     * @param writer The writer with which to write the data
     * @param description The name of the numpy array
     */
    public static void writeNumPyArray(List list, String propertyName, PrintWriter writer, String description) {
        writer.print(description + " = array([");
        boolean firstTime = true;
        try {
            for (Object object : list) {
                Object value = object.getClass().getField(propertyName).get(object);
                if (firstTime) writer.print(value);
                else writer.print(", " + value);
                firstTime = false;
            }
            writer.println("])");
            writer.flush();
        } catch (NoSuchFieldException | IllegalAccessException e) {
            e.printStackTrace();
        }
    }
}
