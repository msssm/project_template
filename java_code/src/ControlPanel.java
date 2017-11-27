import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

public class ControlPanel extends JPanel implements PropertyChangeListener {

    private Simulation simulation;
    private JButton startPauseButton;
    private JButton restartButton;
    private JLabel epsilonLabel, muLabel, alphaLabel, gammaLabel, percLabel, rPartLabel, sizeLabel, minNeighborsLabel;
    private JFormattedTextField epsilonField, muField, alphaField, gammaField, percField, rPartField, sizeField, minNeighborsField;

    private boolean paused = true;

    public ControlPanel(Simulation simulation) {
        this.simulation = simulation;
        setPreferredSize(new Dimension(500, 230));
        setBackground(Color.WHITE);
        setLayout(new GridLayout(9,2));

        initComponents();
        addListeners();
        addComponents();
    }

    private void initComponents() {
        startPauseButton = new JButton("Start");
        restartButton = new JButton("Reinitialize");

        epsilonLabel = new JLabel("Repulsion Strength (ε)");

        epsilonField = new JFormattedTextField();
        epsilonField.setValue(simulation.epsilon);
        epsilonField.setColumns(10);

        muLabel = new JLabel("Propulsion Strength (µ)");

        muField = new JFormattedTextField();
        muField.setValue(simulation.mu);
        muField.setColumns(10);

        alphaLabel = new JLabel("Flocking Force Strength (α)");

        alphaField = new JFormattedTextField();
        alphaField.setValue(simulation.alpha);
        alphaField.setColumns(10);

        gammaLabel = new JLabel("Centripetal Force Strength (γ)");

        gammaField = new JFormattedTextField();
        gammaField.setValue(simulation.gamma);
        gammaField.setColumns(10);

        percLabel = new JLabel("Percentage of Initial Participants");

        percField = new JFormattedTextField();
        percField.setValue(simulation.percentParticipating);
        percField.setColumns(10);

        rPartLabel = new JLabel("Search Radius for Part. Neighbors");

        rPartField = new JFormattedTextField();
        rPartField.setValue(simulation.rParticipating);
        rPartField.setColumns(10);

        sizeLabel = new JLabel("Minimum Circle Pit Size");

        sizeField = new JFormattedTextField();
        sizeField.setValue(simulation.minCirclePitSize);
        sizeField.setColumns(10);

	    minNeighborsLabel = new JLabel("Neighbors Needed to Join in Circle Pit");

        minNeighborsField = new JFormattedTextField();
        minNeighborsField.setValue(simulation.minParticipatingNeighbors);
        minNeighborsField.setColumns(10);

    }

    private void addListeners() {
        startPauseButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (paused) {
                    simulation.getSimulationTimer().start();
                    startPauseButton.setText("Pause");
                }
                else {
                    simulation.getSimulationTimer().stop();
                    startPauseButton.setText("Start");
                }
                paused = !paused;
            }
        });

        restartButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
//                double epsilon = ((Number) epsilonField.getValue()).doubleValue();
//                double mu = ((Number) muField.getValue()).doubleValue();
//                double alpha = ((Number) alphaField.getValue()).doubleValue();
//                double gamma = ((Number) gammaField.getValue()).doubleValue();
//                double numberOfPeople = simulation.numberOfPeople;
//                double flockRadius = simulation.flockRadius;
//                double dt = simulation.dt;
//                double percentParticipating = ((Number) percField.getValue()).doubleValue();
//                double rParticipating = ((Number) rPartField.getValue()).doubleValue();
//                int minCirclePitSize = ((Number) sizeField.getValue()).intValue();
//                int minParticipatingNeighbors = ((Number) minNeighborsField.getValue()).intValue();
//                simulation = new Simulation(epsilon, mu, alpha, gamma, numberOfPeople, flockRadius, dt, percentParticipating, rParticipating, minCirclePitSize, minParticipatingNeighbors);
//                gui.remove(panel);
//                panel = new SimulationPanel(500, 500, simulation.getMatrix().getIndividuals(), 10, 10);
//                gui.add(panel, BorderLayout.CENTER);
//                simulation.runSimulation();
                startPauseButton.setText("Start");
                paused = true;
                simulation.resetMatrix();
            }
        });

        epsilonField.addPropertyChangeListener("value", this);
        alphaField.addPropertyChangeListener("value", this);
        muField.addPropertyChangeListener("value", this);
        gammaField.addPropertyChangeListener("value", this);

        percField.addPropertyChangeListener("value", this);
        rPartField.addPropertyChangeListener("value", this);
        sizeField.addPropertyChangeListener("value", this);
        minNeighborsField.addPropertyChangeListener("value", this);
    }

    private void addComponents() {
        add(startPauseButton);
        add(restartButton);
        add(epsilonLabel);
        add(epsilonField);
        add(muLabel);
        add(muField);
        add(alphaLabel);
        add(alphaField);
        add(gammaLabel);
        add(gammaField);
	    add(percLabel);
        add(percField);
	    add(rPartLabel);
        add(rPartField);
	    add(sizeLabel);
        add(sizeField);
	    add(minNeighborsLabel);
        add(minNeighborsField);

        setVisible(true);
    }

    /**
     * Called when a field's "value" property changes.
     */
    @Override
    public void propertyChange(PropertyChangeEvent e) {
        Object source = e.getSource();
        if (source == epsilonField) {
            simulation.epsilon = ((Number) epsilonField.getValue()).doubleValue();
        } else if (source == muField) {
            simulation.mu = ((Number) muField.getValue()).doubleValue();
        } else if (source == alphaField) {
            simulation.alpha = ((Number) alphaField.getValue()).doubleValue();
        } else if (source == gammaField) {
            simulation.gamma = ((Number) gammaField.getValue()).doubleValue();
        } else if (source == percField) {
            simulation.percentParticipating = ((Number) percField.getValue()).doubleValue();
	   // simulation.initializeMatrix();    --> should restart but I didn't find out how to do it
        } else if (source == rPartField) {
            simulation.rParticipating = ((Number) rPartField.getValue()).doubleValue();
	    } else if (source == sizeField) {
            simulation.minCirclePitSize = ((Number) sizeField.getValue()).intValue();
	    } else if (source == minNeighborsField) {
            simulation.minParticipatingNeighbors = ((Number) minNeighborsField.getValue()).intValue();
    	}
}
}
