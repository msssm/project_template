import java.io.FileNotFoundException;

public class Main {
    public static void main(String[] args) throws FileNotFoundException {
        // Run a manual simulation
        // Simulation simulation = new Simulation(2, 10, 700, 600,500, 8,
        //                                        0.01, 0.5, 6, 1, 3);
        // simulation.runManualSimulation();

        // Run an automatic simulation
        AutomaticSimulator test = new AutomaticSimulator();
        test.run();
    }
}
