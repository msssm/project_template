public class Test {
    public static void main(String[] args) {
        Simulation simulation = new Simulation(1000, 10, 1000, 100, 20, 0.01, 0.5, 2000, 1, 3);

        // Testing the initialization
        for (int i = 0; i < simulation.getMatrix().width; i++) {
            for (int j = 0; j < simulation.getMatrix().height; j++) {
                System.out.println("=================== Sector: (" + i + ", " + j + ") =====================");
                for (Individual individual : simulation.getMatrix().get(i, j)) {
                    System.out.println(individual);
                }
                System.out.println("");
            }
        }

//        // Testing the efficiency of getNeighbors (MUCH faster than MATLAB!)
//        long start = System.nanoTime();
////        simulation.matrix.getNeighborsFor(simulation.matrix.get(0, 0).get(0), 10);
//        long end = System.nanoTime();
//        System.out.println(end - start);
//
//        // Testing the efficiency of one timestep
//        start = System.nanoTime();
//        simulation.runOneTimestep();
//        end = System.nanoTime();
//        System.out.println(end - start);

        simulation.runSimulation();
    }
}
