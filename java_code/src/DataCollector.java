import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

public class DataCollector implements ActionListener {

    private Simulation simulation;  // Simulation for which to collect data

    private PrintWriter fileCounterWriter;  // Writer to
    private PrintWriter outWriter;
    private int seedCounter = 0;
    private int timeCounter = 0;
    private final static int MAX_TIME = 3;
    private final static int MAX_SEEDS = 2;
    private final int timeStepInterval;
    private int realTimeElapsed = 0;
    private final int dataCollectionInterval;

    private int counter = 0;

    private String configurationName;

    public DataCollector(Simulation simulation, String configurationName, int timeStepInterval, int dataCollectionInterval) {
        this.simulation = simulation;
        this.timeStepInterval = timeStepInterval;
        this.dataCollectionInterval = dataCollectionInterval;
        File file = new File(configurationName + "/out_0_0.py");
        file.getParentFile().mkdirs();
        try {
            fileCounterWriter = new PrintWriter("counter.py");
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
        realTimeElapsed += timeStepInterval;
        performCustomStuff();
        if (realTimeElapsed % dataCollectionInterval == 0) {
            realTimeElapsed = 0;


            outWriter.println("from numpy import *");
            outWriter.flush();

            writePositionData(matrix);
            writeDangerLevelData(matrix);
            writeForceData(matrix);
            writeDensityData(matrix);
            writeIsParticipatingData(matrix);
            writeAverageDanger(matrix);
            writeMaxDanger(matrix);

            if (timeCounter >= MAX_TIME) {
                timeCounter = 0;
                simulation.setSeed(seedCounter);
                seedCounter++;
                simulation.restartSimulation();
            }
            if (seedCounter >= MAX_SEEDS) {
                fileCounterWriter.println("n = " + MAX_TIME);
                fileCounterWriter.println("m = " + MAX_SEEDS);
                fileCounterWriter.flush();
                fileCounterWriter.close();
                outWriter.flush();
                outWriter.close();
                System.exit(0);
            }

            resetWriters(configurationName + "/out_" + seedCounter + "_" + timeCounter + ".py");

            timeCounter++;
        }
    }

    private void writePositionData(PositionMatrix matrix) {
        outWriter.print("x = array([");
        boolean firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) outWriter.print(individual.x);
            else outWriter.print(", " + individual.x);
            firstTime = false;
        }
        outWriter.println("])");
        outWriter.flush();

        outWriter.print("y = array([");
        firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) outWriter.print(individual.y);
            else outWriter.print(", " + individual.y);
            firstTime = false;
        }
        outWriter.println("])");
        outWriter.flush();
    }

    private void writeDangerLevelData(PositionMatrix matrix) {
        outWriter.print("dangerLevel = array([");
        boolean firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) outWriter.print(individual.dangerLevel);
            else outWriter.print(", " + individual.dangerLevel);
            firstTime = false;
        }
        outWriter.println("])");
        outWriter.flush();
    }

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

    private void writeForceData(PositionMatrix matrix) {
        outWriter.print("F = array([");
        boolean firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) outWriter.print(individual.f);
            else outWriter.print(", " + individual.f);
            firstTime = false;
        }
        outWriter.println("])");
        outWriter.flush();
    }

    private void writeDensityData(PositionMatrix matrix) {
        outWriter.print("density = array([");
        boolean firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) outWriter.print(individual.density);
            else outWriter.print(", " + individual.density);
            firstTime = false;
        }
        outWriter.println("])");
        outWriter.flush();
    }

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

    private void writeMaxDanger(PositionMatrix matrix) {
        outWriter.print("maxDanger = ");
        double maxDanger = -1;
        for (Individual individual : matrix.getIndividuals()) {
            maxDanger += Math.max(maxDanger, individual.f / 10000 + individual.density / 50);
        }
        outWriter.println(maxDanger);
        outWriter.flush();
    }

    private void resetWriters(String newOutFileName) {
        try {
            outWriter.close();
            outWriter = new PrintWriter(newOutFileName, "UTF-8");
        } catch (FileNotFoundException | UnsupportedEncodingException e3) {
            e3.printStackTrace();
        }
    }

    public void performCustomStuff() {}
}
