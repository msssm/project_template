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
    private JLabel epsilonLabel, alphaLabel;
    private JFormattedTextField field1, field2;

    public ControlPanel(Simulation simulation) {
        this.simulation = simulation;
        setSize(new Dimension(500, 300));
        setPreferredSize(new Dimension(500, 100));
        setMinimumSize(new Dimension(500, 300));
        setBackground(Color.WHITE);
        setLayout(new GridLayout(3,2));

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

    }

    private void addComponents() {
        add(startButton);
        add(pauseButton);
        add(epsilonLabel);
        add(field1);
        add(alphaLabel);
        add(field2);
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
        }

    }
}
