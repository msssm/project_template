import javax.swing.*;
import java.awt.*;
import java.awt.geom.Ellipse2D;

/**
 * Draws the matrix into a JPanel.
 */
public class SimulationPanel extends JPanel {

    private final int WIDTH;
    private final int HEIGHT;
    private java.util.List<Individual> individuals;
    private double xScalingFactor, yScalingFactor;

    public SimulationPanel(int width, int height, java.util.List<Individual> individuals, int matrixWidth, int matrixHeight) {
        WIDTH = width;
        HEIGHT = height;
        this.individuals = individuals;
        xScalingFactor = width / matrixWidth;
        yScalingFactor = height / matrixHeight;
        this.setSize(new Dimension(width, height));
        this.setPreferredSize(new Dimension(width, height));
        this.setMinimumSize(new Dimension(width, height));
        this.setBackground(Color.WHITE);
    }

    @Override
    public void paintComponent(Graphics g) {
        Graphics2D graphics2D = (Graphics2D) g.create();
        graphics2D.fillRect(0, 0, 10, 10);
        graphics2D.setColor(Color.BLACK);
        for (Individual individual : individuals) {
//            System.out.println(individual);
            double[] coords = individual.getCenter();
            coords[0] *= xScalingFactor;
            coords[1] *= yScalingFactor;
            graphics2D.fill(new Ellipse2D.Double(coords[0], coords[1], individual.radius * xScalingFactor, individual.radius * yScalingFactor));
        }

        g.dispose();
    }
}
