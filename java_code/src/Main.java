public class Main {
    public static void main(String[] args) {
//        PoliceSimulation simulation = new PoliceSimulation(2, 10, 700, 300,500, 20, 0.01, 0.5, 20, 1, 3);
//        simulation.setMonitoredSectors(0, 0, 0, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8);
//        simulation.runSimulation();

        Simulation simulation = new Simulation(2, 10, 700, 300,500, 20, 0.01, 0.5, 20, 1, 3);
        simulation.shouldStoreData = true;
        simulation.runSimulation();
    }
}
