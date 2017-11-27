import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

public class ControlPanel extends JPanel implements PropertyChangeListener {

    private Simulation simulation;
    private JButton startButton;
    private JButton pauseButton;
    private JLabel epsilonLabel, muLabel, alphaLabel, percLabel, rPartLabel, sizeLabel, minNeighborsLabel;
    private JFormattedTextField epsilonField, muField, alphaField, percField, rPartField, sizeField, minNeighborsField;

    public ControlPanel(Simulation simulation) {
        this.simulation = simulation;
        setPreferredSize(new Dimension(500, 200));
        setBackground(Color.WHITE);
        setLayout(new GridLayout(8,2));

        initComponents();
        addListeners();
        addComponents();
    }

    private void initComponents() {
        startButton = new JButton("Start");
        pauseButton = new JButton("Pause");

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
        startButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                simulation.getSimulationTimer().start();
            }
        });

        pauseButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                simulation.getSimulationTimer().stop();
            }
        });

        epsilonField.addPropertyChangeListener("value", this);
        alphaField.addPropertyChangeListener("value", this);
        muField.addPropertyChangeListener("value", this);

        percField.addPropertyChangeListener("value", this);
        rPartField.addPropertyChangeListener("value", this);
        sizeField.addPropertyChangeListener("value", this);
        minNeighborsField.addPropertyChangeListener("value", this);
    }

    private void addComponents() {
        add(startButton);
        add(pauseButton);
        add(epsilonLabel);
        add(epsilonField);
        add(muLabel);
        add(muField);
        add(alphaLabel);
        add(alphaField);
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
