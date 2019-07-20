import javax.swing.*;
import java.awt.*;

public class SimulationGUI extends JFrame {

    private SimulationPanel simulationPanel;
    private ControlPanel controlPanel;
    private Simulation simulation;

    public SimulationGUI(Simulation simulation) {
        this.simulation = simulation;
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (UnsupportedLookAndFeelException e) {
            e.printStackTrace();
        }
        setTitle("Circle Pit Simulation");
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());
        setResizable(false);

        initComponents();
        addComponents();
        pack();
        setLocationRelativeTo(null);
    }

    private void initComponents() {
        PositionMatrix matrix = simulation.getMatrix();
        simulationPanel = new SimulationPanel(500, 500, simulation,
                                              matrix.width * matrix.sectorSize,
                                              matrix.height *
                                                      matrix.sectorSize);

        controlPanel = new ControlPanel(simulation, simulationPanel);
    }

    private void addComponents() {
        add(simulationPanel, BorderLayout.CENTER);
        add(controlPanel, BorderLayout.EAST);
    }

    /**
     * Resets the simulation panel.
     */
    public void resetSimulationPanel() {
        simulationPanel.setIndividuals(simulation.getMatrix().getIndividuals());
    }
}
