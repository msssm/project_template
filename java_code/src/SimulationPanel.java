import javax.swing.*;
import java.awt.*;
import java.awt.geom.Ellipse2D;

/**
 * Draws the matrix into a JPanel.
 */
public class SimulationPanel extends JPanel {

    private java.util.List<Individual> individuals;
    private double xScalingFactor, yScalingFactor;
    public boolean enableParticipatingButton;

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
            
            int dangerLevel = individual.dangerLevel;
            if (dangerLevel == 0 ) {
            	graphics2D.setColor(new Color(204,229,255));
            } else if (dangerLevel == 1) {
            	graphics2D.setColor(new Color(154, 204, 255));
            } else if (dangerLevel == 2) {
            	graphics2D.setColor(new Color(51, 153,255 ));
            } else if (dangerLevel ==3) {
            	graphics2D.setColor(new Color(0,128,255));
            } else if (dangerLevel == 4) {
            	graphics2D.setColor(new Color(0, 76, 153));
            } else if (dangerLevel ==5 ){
            	graphics2D.setColor(new Color(255,0,0));
            } else if (dangerLevel == 6){
            	graphics2D.setColor(new Color(76, 153, 0));
            }


            graphics2D.fill(new Ellipse2D.Double(coords[0], coords[1], individual.radius * xScalingFactor, individual.radius * yScalingFactor));
			if (enableParticipatingButton) {
				if (!individual.isParticipating) {
					graphics2D.setColor(Color.WHITE);
					graphics2D.fill(new Ellipse2D.Double(coords[0] + individual.radius * xScalingFactor / 4,
							coords[1] + individual.radius * yScalingFactor / 4, individual.radius * xScalingFactor / 2,
							individual.radius * yScalingFactor / 2));

				}
			}

        }
        g.dispose();
    }
    

}
