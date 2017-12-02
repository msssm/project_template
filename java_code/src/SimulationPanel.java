import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.JPanel;

/**
 * Draws the matrix into a JPanel.
 */
public class SimulationPanel extends JPanel {

    private java.util.List<Individual> individuals;
    private double xScalingFactor, yScalingFactor;
    private int sumDanger;
    public boolean enableParticipatingButton;
    private Simulation simulation;
    private BufferedImage image;

    public SimulationPanel(int width, int height, Simulation simulation, int matrixWidth, int matrixHeight) {
        this.individuals = simulation.getMatrix().getIndividuals();
        xScalingFactor = width / matrixWidth;
        yScalingFactor = height / matrixHeight;
        this.simulation = simulation;
        try {
			image = ImageIO.read(new File("policeman.png"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        this.setSize(new Dimension(width, height));
        this.setPreferredSize(new Dimension(width, height));
        this.setMinimumSize(new Dimension(width, height));
        this.setBackground(Color.WHITE);
        addListeners();
        setFocusable(false);
    }

    private void addListeners() {
        this.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                double x = e.getX() / xScalingFactor;
                double y = e.getY() / yScalingFactor;
                System.out.println(x);
                System.out.println(y);
                PositionMatrix.Sector sector = simulation.getMatrix().getSectorForCoords(x, y);
                simulation.getMatrix().isPoliceAtSector[sector.row][sector.col] = !simulation.getMatrix().isPoliceAtSector[sector.row][sector.col];
            }
        });
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
        sumDanger = 0;
        Graphics2D graphics2D = (Graphics2D) g.create();
        Graphics2D generalDanger = (Graphics2D) g.create();
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
            	graphics2D.setColor(new Color(102, 178,255 ));
            } else if (dangerLevel ==3) {
                sumDanger++;
            	graphics2D.setColor(new Color(51,153,255));
            } else if (dangerLevel == 4) {
                sumDanger += 2;
            	graphics2D.setColor(new Color(0,128,255));
            } else if (dangerLevel ==5 ){
                sumDanger += 3;
            	graphics2D.setColor(new Color(0,102,204));
            } else if (dangerLevel == 6){
                sumDanger += 4;
            	graphics2D.setColor(new Color(255, 51, 51));
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

        generalDanger.setColor(new Color(102, 102, 0));
        generalDanger.fill(new Rectangle2D.Double(0, 10, 13, sumDanger/5));
        generalDanger.setColor(new Color(204, 204, 0));
        generalDanger.fill(new Rectangle2D.Double(1, 11, 11, sumDanger/5 - 2));
        boolean[][] monitoredSectors = simulation.getMatrix().isPoliceAtSector;
        for (int i = 0; i < monitoredSectors.length; i++) {
        	for (int j = 0; j < monitoredSectors[i].length; j++) {
        		if (monitoredSectors[i][j]) {
        			graphics2D.drawImage(image, (int)((i * 10 + 4) * xScalingFactor), (int)((j * 10 + 4) * yScalingFactor), (int)(3 * xScalingFactor), (int)(3 * yScalingFactor), null);
        		}
        	}
        }
        g.dispose();
    }
    

}
