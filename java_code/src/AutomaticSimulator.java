import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

/**
 * An object that reads the configs given in <code>configs.sim</code> and executes the corresponding simulations while
 * dumping data for analysis.
 */
public class AutomaticSimulator {

    private Queue<String> configNames = new ArrayDeque<>();  // The configs to simulate
    private Simulation simulation;

    // A class that stores all the parameters from a config file
    private class Config {
        String name;
        double epsilon, alpha, mu, gamma, dt, percentParticipating;
        int numberOfPeople, flockRadius, rParticipating, minCirclePitSize, minParticipatingNeighbors, dataCollectionInterval,
                insertPoliceAfter, collectionTimes, amountOfSeeds;
        boolean[][] policeSectors = new boolean[10][10];

        private void readNumbersFromArray(double[] array) {
            assert array.length == 15;
            epsilon = array[0];
            mu = array[1];
            alpha = array[2];
            gamma = array[3];
            numberOfPeople = (int) array[4];
            flockRadius = (int) array[5];
            dt = array[6];
            percentParticipating = array[7];
            rParticipating = (int) array[8];
            minCirclePitSize = (int) array[9];
            minParticipatingNeighbors = (int) array[10];
            dataCollectionInterval = (int) array[11];
            insertPoliceAfter = (int) array[12];
            collectionTimes = (int) array[13];
            amountOfSeeds = (int) array[14];
        }
    }

    public AutomaticSimulator() throws FileNotFoundException {
        readConfigNames();
    }

    /**
     * Runs the automatic simulation.
     * @throws FileNotFoundException either if <code>configs.sim</code> could not be found or if a configuration
     * specified in <code>configs.sim</code> could not be found.
     */
    public void run() throws FileNotFoundException {
        // Keep going while not all configurations have been tested
        while (!configNames.isEmpty()) {
            String config = configNames.poll();
            Config c = readConfigFile(config);
            newSimulation(c);
            // Poll the simulation to see if it is done yet (really ugly but oh well...)
            while (!simulation.isCurrentIterationFinished) {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            simulation.isCurrentIterationFinished = false;
        }
        System.exit(0);
    }

    // Reads the configurations to simulate from configs.sim
    private void readConfigNames() throws FileNotFoundException {
        Scanner scanner = new Scanner(new File("configs.sim"));
        scanner.nextLine();
        while (scanner.hasNext()) {
            configNames.add(scanner.next());
        }
        System.out.println("Starting simulation with configs: " + configNames);
    }

    // Reads a configuration file
    private Config readConfigFile(String config) throws FileNotFoundException {
        Scanner scanner = new Scanner(new File("configs/" + config + ".config"));
        scanner.nextLine();  // Skip comment on first line
        double[] data = new double[15];
        Config c = new Config();
        c.name = config;
        for (int i = 0; i < data.length; i++) {  // Read parameters from config file
            scanner.next();
            data[i] = scanner.nextDouble();
        }
        c.readNumbersFromArray(data);
        scanner.nextLine();  // Move to line after all the number values
        scanner.nextLine();  // Move over line with "policeSectors: "
        scanner.nextLine();  // Move over upper boundary of ASCII-based representation of matrix
        for (int i = 0; i < 10; i++) {
            String line = scanner.nextLine();
            for (int j = 0; j < 10; j++) {
                if (line.charAt(j+1) == 'x') {  // j+1 because of leading |, 'x' means there is a policeman there
                    c.policeSectors[j][i] = true;
                }
            }
        }
        System.out.println("Current config: " + config);
        System.out.println("    data = " + Arrays.toString(data));
        System.out.println("    policeSectors = ");
        for (int i = 0; i < c.policeSectors.length; i++) {
            System.out.println("        " + Arrays.toString(c.policeSectors[i]));
        }
        return c;
    }

    private void newSimulation(Config c) {
        if (simulation == null) {
            // Initialize the simulation with data from the config file
            simulation = new Simulation(c.epsilon, c.mu, c.alpha, c.gamma, c.numberOfPeople, c.flockRadius, c.dt, c.percentParticipating, c.rParticipating, c.minCirclePitSize, c.minParticipatingNeighbors);
            simulation.createWindow();
            simulation.createNewTimer(new DataCollector(simulation, c.name, Simulation.TIMESTEP, c.dataCollectionInterval, c.insertPoliceAfter, c.amountOfSeeds, c.collectionTimes, c.policeSectors));
            simulation.start();
        } else {
            // Reinitialize all the parameters with data from the config file
            simulation.stop();
            simulation.epsilon = c.epsilon;
            simulation.alpha = c.alpha;
            simulation.mu = c.mu;
            simulation.gamma = c.gamma;
            simulation.numberOfPeople = c.numberOfPeople;
            simulation.flockRadius = c.flockRadius;
            simulation.dt = c.dt;
            simulation.percentParticipating = c.percentParticipating;
            simulation.rParticipating = c.rParticipating;
            simulation.minCirclePitSize = c.minCirclePitSize;
            simulation.minParticipatingNeighbors  = c.minParticipatingNeighbors;
            simulation.createNewTimer(new DataCollector(simulation, c.name, Simulation.TIMESTEP, c.dataCollectionInterval, c.insertPoliceAfter, c.amountOfSeeds, c.collectionTimes, c.policeSectors));
            simulation.basicReset();
            simulation.start();
        }
    }
}
