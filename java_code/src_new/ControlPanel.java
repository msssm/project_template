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
    private JLabel epsilonLabel, alphaLabel, percLabel, rPartLabel, minLabel, maxLabel;
    private JFormattedTextField field1, field2, field3, field4, field5, field6;

    public ControlPanel(Simulation simulation) {
        this.simulation = simulation;
        setSize(new Dimension(500, 300));
        setPreferredSize(new Dimension(500, 100));
        setMinimumSize(new Dimension(500, 300));
        setBackground(Color.WHITE);
        setLayout(new GridLayout(7,2));

        initComponents();
        addListeners();
        addComponents();
    }

    private void initComponents() {
        startButton = new JButton("Start");
        pauseButton = new JButton("Pause");

        epsilonLabel = new JLabel("Repulsion (ε)");

        field1 = new JFormattedTextField();
        field1.setValue(50000d);
        field1.setColumns(10);

        alphaLabel = new JLabel("Flocking Force (α)");

        field2 = new JFormattedTextField();
        field2.setValue(100000d);
        field2.setColumns(10);

        percLabel = new JLabel("Percentage of initial participant");

        field3 = new JFormattedTextField();
        field3.setValue(0.5d);
        field3.setColumns(10);

        rPartLabel = new JLabel("Radius of 'isParticiping'");

        field4 = new JFormattedTextField();
        field4.setValue(100d);
        field4.setColumns(10);

        minLabel = new JLabel("People min to still participate");

        field5 = new JFormattedTextField();
        field5.setValue(1);
        field5.setColumns(10);

	maxLabel = new JLabel("People needed to start participate");

        field6 = new JFormattedTextField();
        field6.setValue(2);
        field6.setColumns(10);

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

        field1.addPropertyChangeListener("value", this);
        field2.addPropertyChangeListener("value", this);

        field3.addPropertyChangeListener("value", this);
        field4.addPropertyChangeListener("value", this);
        field5.addPropertyChangeListener("value", this);
        field6.addPropertyChangeListener("value", this);
    }

    private void addComponents() {
        add(startButton);
        add(pauseButton);
        add(epsilonLabel);
        add(field1);
        add(alphaLabel);
        add(field2);
	add(percLabel);
        add(field3);
	add(rPartLabel);
        add(field4);
	add(minLabel);
        add(field5);
	add(maxLabel);
        add(field6);

        setVisible(true);
    }

    /**
     * Called when a field's "value" property changes.
     */
    @Override
    public void propertyChange(PropertyChangeEvent e) {
        Object source = e.getSource();
        if (source == field1) {
            simulation.epsilon = ((Number)field1.getValue()).doubleValue();
        } else if (source == field2) {
            simulation.alpha = ((Number)field2.getValue()).doubleValue();
        } else if (source == field3) {
            simulation.percParticipating = ((Number)field3.getValue()).doubleValue();
	   // simulation.initializeMatrix();    --> should restart but I didn't find out how to do it
        } else if (source == field4) {
            simulation.rParticipating = ((Number)field4.getValue()).doubleValue();
	} else if (source == field5) {
            simulation.minParticipating = ((Number)field5.getValue()).intValue();
	} else if (source == field6) {
            simulation.maxParticipating = ((Number)field6.getValue()).intValue();
    	}
}
}
