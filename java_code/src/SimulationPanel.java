import javax.swing.*;
import java.awt.*;
import java.awt.geom.Ellipse2D;

/**
 * Draws the matrix into a JPanel.
 */
public class SimulationPanel extends JPanel {

    private java.util.List<Individual> individuals;
    private double xScalingFactor, yScalingFactor;

    public SimulationPanel(int width, int height, java.util.List<Individual> individuals, int matrixWidth, int matrixHeight) {
        this.individuals = individuals;
        xScalingFactor = width / matrixWidth;
        yScalingFactor = height / matrixHeight;
        this.setSize(new Dimension(width, height));
        this.setPreferredSize(new Dimension(width, height));
        this.setMinimumSize(new Dimension(width, height));
        this.setBackground(Color.WHITE);
        setFocusable(false);
    }

    /**
     * Sets the individuals list to the given parameter.
     */
    public void setIndividuals(java.util.List<Individual> individuals) {
        this.individuals = individuals;
    }

    private void increaseRenderingQuality(Graphics2D g2d) {
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_DITHERING, RenderingHints.VALUE_DITHER_ENABLE);
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_LCD_CONTRAST, 100);
        g2d.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS, RenderingHints.VALUE_FRACTIONALMETRICS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION, RenderingHints.VALUE_ALPHA_INTERPOLATION_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_COLOR_RENDERING, RenderingHints.VALUE_COLOR_RENDER_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_STROKE_CONTROL,RenderingHints.VALUE_STROKE_PURE);
    }

    @Override
    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D graphics2D = (Graphics2D) g.create();
        increaseRenderingQuality(graphics2D);
        for (Individual individual : individuals) {
            double[] coords = individual.getPosition();
            coords[0] *= xScalingFactor;
            coords[1] *= yScalingFactor;
            graphics2D.setColor(individual.isParticipating ? Color.RED : Color.BLACK);
            graphics2D.fill(new Ellipse2D.Double(coords[0], coords[1], individual.radius * xScalingFactor, individual.radius * yScalingFactor));
        }
        g.dispose();
    }
}
