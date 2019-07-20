import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

public class ControlPanel extends JPanel
        implements PropertyChangeListener, ChangeListener {

    private Simulation simulation;
    private SimulationPanel simulationpanel;
    private JButton startPauseButton;
    private JButton restartButton;
    private JButton exportDataButton;
    private JCheckBox enableDensity;
    private JCheckBox enableForce;
    private JCheckBox showParticipants;
    private JLabel epsilonLabel, muLabel, alphaLabel, flockRadiusLabel,
            gammaLabel, initialParticipantsLabel, percLabel, rPartLabel,
            sizeLabel, minNeighborsLabel;
    private JFormattedTextField epsilonField, muField, alphaField, gammaField,
            initialParticipantsField, percField, sizeField, minNeighborsField;
    private JSlider rPartSlider, flockRadiusSlider;

    private boolean paused = true;

    public ControlPanel(Simulation simulation,
                        SimulationPanel simulationpanel) {
        this.simulation = simulation;
        this.simulationpanel = simulationpanel;
        setPreferredSize(new Dimension(500, 230));
        setBackground(Color.WHITE);
        setLayout(new GridLayout(13, 2));

        initComponents();
        addListeners();
        addComponents();
    }

    private void initComponents() {
        startPauseButton = new JButton("Start");
        restartButton = new JButton("Reinitialize");
        showParticipants = new JCheckBox("Show Participants");
        showParticipants.setSelected(true);
        exportDataButton = new JButton("Export Data for Analysis");

        enableDensity = new JCheckBox("Density is a Danger Factor");
        enableDensity.setSelected(true);
        enableForce = new JCheckBox("Force is a Danger Factor");
        enableForce.setSelected(true);

        epsilonLabel = new JLabel("Repulsion Strength (\u03b5)");

        epsilonField = new JFormattedTextField();
        epsilonField.setValue(simulation.epsilon);
        epsilonField.setColumns(10);

        muLabel = new JLabel("Propulsion Strength (\u03bc)");

        muField = new JFormattedTextField();
        muField.setValue(simulation.mu);
        muField.setColumns(10);

        alphaLabel = new JLabel("Flocking Force Strength (\u03b1)");

        alphaField = new JFormattedTextField();
        alphaField.setValue(simulation.alpha);
        alphaField.setColumns(10);

        flockRadiusLabel = new JLabel("Flocking Force Radius");
        flockRadiusSlider = new JSlider();
        flockRadiusSlider.setValue((int) simulation.flockRadius);
        configureSlider(flockRadiusSlider, 1, 5, 5, 2 * Simulation.SECTOR_SIZE);

        gammaLabel = new JLabel("Centripetal Force Strength (\u03b3)");

        gammaField = new JFormattedTextField();
        gammaField.setValue(simulation.gamma);
        gammaField.setColumns(10);

        initialParticipantsLabel = new JLabel("Initial Size of Crowd");

        initialParticipantsField = new JFormattedTextField();
        initialParticipantsField.setValue(simulation.numberOfPeople);
        initialParticipantsField.setColumns(10);

        percLabel = new JLabel("Percentage of Initial Participants");

        percField = new JFormattedTextField();
        percField.setValue(simulation.percentParticipating);
        percField.setColumns(10);

        rPartLabel = new JLabel("Search Radius for Part. Neighbors");

        rPartSlider = new JSlider();
        rPartSlider.setValue((int) simulation.rParticipating);
        configureSlider(rPartSlider, 1, 10, 0, 2 * Simulation.SECTOR_SIZE);

        sizeLabel = new JLabel("Neighbors Needed to Continue Participating");

        String fontFamily = sizeLabel.getFont().getFamily();
        sizeLabel.setFont(new Font(fontFamily, Font.PLAIN, 11));


        sizeField = new JFormattedTextField();
        sizeField.setValue(simulation.minCirclePitSize);
        sizeField.setColumns(10);

        minNeighborsLabel = new JLabel(
                "Neighbors Needed to Join in Circle Pit");

        minNeighborsField = new JFormattedTextField();
        minNeighborsField.setValue(simulation.minParticipatingNeighbors);
        minNeighborsField.setColumns(10);

    }

    private void configureSlider(JSlider slider, int minorSpacing,
                                 int majorSpacing, int lowerLimit,
                                 int upperLimit) {
        slider.setMajorTickSpacing(majorSpacing);
        slider.setMinorTickSpacing(minorSpacing);
        slider.setMinimum(lowerLimit);
        slider.setMaximum(upperLimit);
        slider.setPaintLabels(true);
        slider.setPaintTicks(true);
    }

    private void addListeners() {
        startPauseButton.addActionListener(new ActionListener() {
            /* @Override */
            public void actionPerformed(ActionEvent e) {
                if (paused) {
                    simulation.getSimulationTimer().start();
                    startPauseButton.setText("Pause");
                } else {
                    simulation.getSimulationTimer().stop();
                    startPauseButton.setText("Start");
                }
                paused = !paused;
            }
        });

        restartButton.addActionListener(new ActionListener() {
            /* @Override */
            public void actionPerformed(ActionEvent e) {
                startPauseButton.setText("Start");
                paused = true;
                simulation.resetMatrix();
            }
        });

        showParticipants.addActionListener(new ActionListener() {
            /* @Override */
            public void actionPerformed(ActionEvent e) {
                simulationpanel.shouldShowParticipants =
                        !simulationpanel.shouldShowParticipants;
                getParent().repaint();
            }
        });

        exportDataButton.addActionListener(new ActionListener() {
            /* @Override */
            public void actionPerformed(ActionEvent e) {
                simulation.exportData();
            }
        });

        enableDensity.addActionListener(new ActionListener() {
            /* @Override */
            public void actionPerformed(ActionEvent e) {
                if (!simulation.enableDensity) {
                    simulation.enableDensity = true;
                } else {
                    simulation.enableDensity = false;
                    for (Individual individual : simulation.getMatrix()
                                                           .getIndividuals()) {
                        individual.dangerLevel = 0;
                    }
                }
            }
        });

        enableForce.addActionListener(new ActionListener() {
            /* @Override */
            public void actionPerformed(ActionEvent e) {
                if (!simulation.enableForce) {
                    simulation.enableForce = true;
                } else {
                    simulation.enableForce = false;
                    for (Individual individual : simulation.getMatrix()
                                                           .getIndividuals()) {
                        individual.dangerLevel = 0;
                    }
                }
            }
        });

        epsilonField.addPropertyChangeListener("value", this);
        alphaField.addPropertyChangeListener("value", this);
        flockRadiusSlider.addChangeListener(this);
        muField.addPropertyChangeListener("value", this);
        gammaField.addPropertyChangeListener("value", this);
        initialParticipantsField.addPropertyChangeListener("value", this);
        percField.addPropertyChangeListener("value", this);
        rPartSlider.addChangeListener(this);
        sizeField.addPropertyChangeListener("value", this);
        minNeighborsField.addPropertyChangeListener("value", this);
    }

    private void addComponents() {
        add(startPauseButton);
        add(restartButton);
        add(showParticipants);
        add(exportDataButton);
        add(enableDensity);
        add(enableForce);
        add(epsilonLabel);
        add(epsilonField);
        add(muLabel);
        add(muField);
        add(alphaLabel);
        add(alphaField);
        add(flockRadiusLabel);
        add(flockRadiusSlider);
        add(gammaLabel);
        add(gammaField);
        add(initialParticipantsLabel);
        add(initialParticipantsField);
        add(percLabel);
        add(percField);
        add(rPartLabel);
        add(rPartSlider);
        add(sizeLabel);
        add(sizeField);
        add(minNeighborsLabel);
        add(minNeighborsField);

        setVisible(true);
    }

    /**
     * Called when a field's "value" property changes.
     */
    /* @Override */
    public void propertyChange(PropertyChangeEvent e) {
        Object source = e.getSource();
        if (source == epsilonField) {
            simulation.epsilon =
                    ((Number) epsilonField.getValue()).doubleValue();
        } else if (source == muField) {
            simulation.mu = ((Number) muField.getValue()).doubleValue();
        } else if (source == alphaField) {
            simulation.alpha = ((Number) alphaField.getValue()).doubleValue();
        } else if (source == gammaField) {
            simulation.gamma = ((Number) gammaField.getValue()).doubleValue();
        } else if (source == initialParticipantsField) {
            simulation.numberOfPeople =
                    ((Number) initialParticipantsField.getValue()).intValue();
        } else if (source == percField) {
            simulation.percentParticipating =
                    ((Number) percField.getValue()).doubleValue();
        } else if (source == rPartSlider) {
            simulation.rParticipating =
                    ((Number) rPartSlider.getValue()).doubleValue();
        } else if (source == sizeField) {
            simulation.minCirclePitSize =
                    ((Number) sizeField.getValue()).intValue();
        } else if (source == minNeighborsField) {
            simulation.minParticipatingNeighbors =
                    ((Number) minNeighborsField.getValue()).intValue();
        }
    }

    /* @Override */
    public void stateChanged(ChangeEvent e) {
        JSlider source = (JSlider) e.getSource();
        if (source == rPartSlider && !source.getValueIsAdjusting()) {
            simulation.rParticipating = (double) rPartSlider.getValue();
        } else if (source == flockRadiusSlider &&
                !source.getValueIsAdjusting()) {
            simulation.flockRadius = (double) flockRadiusSlider.getValue();
        }
    }
}
