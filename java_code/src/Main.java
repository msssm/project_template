import java.io.FileNotFoundException;

public class Main {
    public static void main(String[] args) throws FileNotFoundException {

//        Simulation simulation = new Simulation(2, 10, 700, 600,500, 8, 0.01, 0.5, 6, 1, 3);
////        Timer timer = new Timer(2000, new DataCollector(simulation, "test"));
//        simulation.runAutomaticSimulation();
////        timer.start();
        AutomaticSimulator test = new AutomaticSimulator();
        test.run();
    }
}
