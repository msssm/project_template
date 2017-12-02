import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.swing.Timer;

// TODO: Find a way to restart the simulation
public class Simulation {

    /**
     * Strength of repulsive force
     */
    public double epsilon;

    /**
     * Strength of propulsion
     */
    public double mu;

    /**
     * Strength of flocking force
     */
    public double alpha;

    /**
     * Strength of the centripetal force
     */
    public double gamma;

    /**
     * Number of people in the simulation
     */
    public double numberOfPeople;

    /**
     * Radius within which velocity of neighbors has an effect on the flocking force
     */
    public double flockRadius;

    /**
     * Timestep of the simulation
     */
    public double dt;

    /**
     * Size of one sector of the matrix
     */
    public static final int SECTOR_SIZE = 10;

    /**
     * Percentage of people initially participating in the circle pit
     */
	public double percentParticipating;

    /**
     * Radius within which the 'isParticipating' of neighbors affects the individual
     */
	public double rParticipating;

    /**
     * Minimum amount of people necessary to constitute a circle pit
     */
	public int minCirclePitSize;  // how many people around max not to participate

    /**
     * Necessary number of neighbors participating to start participating
     */
    public int minParticipatingNeighbors;  // how many to start participate

    /**
     * Center of the matrix
     */
    public double[] center;

    /**
     * Window with the simulation
     */
    public SimulationGUI window;

    /**
     * Safe density level
     */
    public int safeDensity = 8;

    /**
     * Density danger level 1
     */
    public int density1 = 10;

    /**
     * Density danger level 2
     */
    public int density2 = 15;

    /**
     * Density danger level 3
     */
    public int density3 = 40;
    

    
    /**
     * safe Force danger level 
     */
    public int safeForce = 10;
    /**
     * Force danger level 1
     */
    public int force1 = 20;
    /**
     * Density danger level 2
     */
    public int force2 = 30;
    /**
     * Density danger level 3
     */
    public int force3 = 40;
    
    public boolean enableForce=true;
    public boolean enableDensity=true;

    public boolean shouldStoreData = false;

    protected PrintWriter writer;

    private double maxX;  // Right-hand border of the terrain
	private double maxY;  // Bottom border of the terrain
	private Timer timer;

	protected PositionMatrix matrix;

	public Simulation() {

    }

	public Simulation(double epsilon, double mu, double alpha, double gamma, double numberOfPeople, double flockRadius, double dt, double percentParticipating, double rParticipating, int minCirclePitSize, int minParticipatingNeighbors) {
		this.epsilon = epsilon;
		this.mu = mu;
		this.alpha = alpha;
		this.gamma = gamma;
		this.numberOfPeople = numberOfPeople;
		this.flockRadius = flockRadius;
		this.dt = dt;
		this.percentParticipating = percentParticipating;
		this.rParticipating = rParticipating;
		this.minCirclePitSize = minCirclePitSize;
		this.minParticipatingNeighbors = minParticipatingNeighbors;
        try {
            writer = new PrintWriter("out.txt", "UTF-8");
        } catch (FileNotFoundException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }
		initializeMatrix(0);
	}

	protected void initializeMatrix(int type) {
		// TODO: Calculate optimal matrix size and sector size
		// for now: create some bogus values
		int tempMatrixSize = 10;

		// The maximum x and y values that an individual can have
		maxX = tempMatrixSize * SECTOR_SIZE;
		maxY = tempMatrixSize * SECTOR_SIZE;

		center = new double[] {maxX / 2, maxY / 2};

		if (type == 0) {
            matrix = new PositionMatrix(tempMatrixSize, tempMatrixSize, SECTOR_SIZE);
        } else {
		    matrix = new PolicePositionMatrix(tempMatrixSize, tempMatrixSize, SECTOR_SIZE);
        }

		for (int i = 0; i < numberOfPeople; i++) {
			// Generate random coordinates
			double[] coords = new double[2];
			coords[0] = Math.random() * SECTOR_SIZE * tempMatrixSize;
			coords[1] = Math.random() * SECTOR_SIZE * tempMatrixSize;

			// Generate random velocity
			double[] velocity = new double[] { Math.random() - 0.5, Math.random() - 0.5 };

			// Decide whether individual is initially participating
			boolean isParticipating = Math.random() < percentParticipating;
			
			//levels of danger, 0 is safe, by default it's safe
			int dangerLevel = 0;

			Individual individual = new Individual(coords, velocity, isParticipating, dangerLevel);

			// Add individual to appropriate sector
			matrix.add(individual);
		}
	}

	public void resetMatrix() {
	    timer.stop();
	    initializeMatrix(0);
	    window.resetSimulationPanel();
	    window.repaint();
    }

	// Checks if the given neighbor at the given distance is participating
	private boolean isNeighborParticipating(Individual neighbor, double distance) {
		return neighbor.isParticipating && distance < rParticipating;
	}


	public void runSimulation() {
        window = new SimulationGUI(this);

        // Run a new frame every 50 milliseconds
        timer = new Timer(50, new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                runOneTimestep();
                window.repaint();
            }
        });

		window.setVisible(true);
	}

	/*private*/ void runOneTimestep() {

		// List of al the individuals in the matrix
		List<Individual> individuals = matrix.getIndividuals();

		// Iterate over each individual
		for (Individual individual : individuals) {
			// Sector where the individual is before updating position
			PositionMatrix.Sector initialSector = matrix.getSectorForCoords(individual);
			// Amount of neighbors participating with the radius rParticipating
			int sumParticipating = 0;
			// Forces acting upon individual
			double[] F = { 0.0, 0.0 };
			// Sum of the neighbor velocities
			double[] sumOverVelocities = { 0.0, 0.0 };
			// List of neighbors
			List<Individual> neighbors = matrix.getNeighborsFor(individual, flockRadius);
			// Position and velocity of individual
			double[] position = individual.getPosition();
			double[] velocity = individual.getVelocity();
			double r0 = 2 * individual.radius;
			
			
			// Calculate the danger level
			int numNeighbors = neighbors.size();

//			// We use the number of people in the neighbor list to represent density
			if (enableDensity==true) {
				if(numNeighbors < safeDensity)
					individual.dangerLevel = 0;
				if(numNeighbors > safeDensity)
					individual.dangerLevel = 1;
				if(numNeighbors > density1)
					individual.dangerLevel = 2;
				if(numNeighbors > density2)
					individual.dangerLevel = 3;
			}
				
			

			

			// =========================== CALCULATION OF THE FORCES =================================
			for (Individual neighbor : neighbors) {
				// Make sure we are not using the individual him/herself
				if (neighbor == individual) {
					continue;
				}
				double[] positionNeighbor = neighbor.getPosition();
				double[] velocityNeighbor = neighbor.getVelocity();

				double distance = individual.distanceTo(neighbor);
				
                sumParticipating += isNeighborParticipating(neighbor, distance) ? 1 : 0;

				// Repulsive force
				// We only use neighbors within a radius of 2 * r0

				if (distance < 2 * individual.radius) {
				    F[0] += epsilon * 500 * (individual.x - neighbor.x) / distance;
				    F[1] += epsilon * 500 * (individual.y - neighbor.y) / distance;
                } else if (distance < 2 * r0) {
//					F[0] += epsilon * Math.pow((1 - distance / (2 * r0)), 5 / 2) * (position[0] - positionNeighbor[0])
//							/ distance;
//					F[1] += epsilon * Math.pow((1 - distance / (2 * r0)), 5 / 2) * (position[1] - positionNeighbor[1])
//							/ distance;
                    F[0] += -epsilon * ((1 / (distance - 2 * r0)) * (position[0] - positionNeighbor[0])) / distance;
                    F[1] += -epsilon * ((1 / (distance - 2 * r0)) * (position[1] - positionNeighbor[1])) / distance;
                }

				sumOverVelocities[0] += velocityNeighbor[0];
				sumOverVelocities[1] += velocityNeighbor[1];
			}
			
			//calculate the scalar of the force
			double jointForce = norm(F);
		
			//TODO need to set different levels for jointForce
			if(enableForce) {
				if(jointForce < safeForce)
					individual.dangerLevel = 0;
				if(jointForce > safeForce)
					individual.dangerLevel = 1;
				if(jointForce > force1)
					individual.dangerLevel = 2;
				if(jointForce > force2)
					individual.dangerLevel = 3;
			}
			if(enableForce && enableDensity) {
				individual.dangerLevel*=2;
			}

			if (sumParticipating >= minParticipatingNeighbors) {
				individual.isParticipating = true;
			}

			if (sumParticipating < minCirclePitSize) {
				individual.isParticipating = false;
			}

			performAdditionalCalculations(individual);

			individual.preferredSpeed = individual.isParticipating ? 30 : 5 * Math.random();

			// Propulsion
			// Makes the individual want to travel at their preferred speed
            double vi = individual.preferredSpeed;
            F[0] += -mu*(norm(velocity)-vi)*velocity[0]/norm(velocity);
            F[1] += -mu*(norm(velocity)-vi)*velocity[1]/norm(velocity);

			// Flocking
			if (individual.isParticipating && !(sumOverVelocities[0] == 0 && sumOverVelocities[1] == 0)) {
				double norm = norm(sumOverVelocities);
				F[0] += alpha * sumOverVelocities[0] / norm;
				F[1] += alpha * sumOverVelocities[1] / norm;
			}


			// Centripetal Force
			if (individual.isParticipating) {
                double distanceToCenter = individual.distanceTo(center);

                // Normalized vector from center to individual
                double[] r = new double[]{center[0] - individual.x, center[1] - individual.y};
                r[0] /= distanceToCenter;
                r[1] /= distanceToCenter;

                F[0] += gamma * r[0];
                F[1] += gamma * r[1];
            }

			// Add noise
			// TODO: Generate noise

            // Make sure that F does not become too large to fit into a double
            double normOfF = norm(F);

            if (normOfF > Long.MAX_VALUE) {
                F[0] /= normOfF * Long.MAX_VALUE;
                F[1] /= normOfF * Long.MAX_VALUE;
            }

			// ======================= CALCULATE TIMESTEP ========================
			// Using the leap-frog method to integrate the differential equation
			// d^2y/dt^2 = rhs(y)

			// Shifted initial velocity for leap-frog
			double[] v_temp = new double[2];
			v_temp[0] = velocity[0] + 0.5 * dt * F[0];
			v_temp[1] = velocity[1] + 0.5 * dt * F[1];

			// New position of the individual
			double newX = position[0] + dt * v_temp[0];
			double newY = position[1] + dt * v_temp[1];

			// New velocity of the individual
			double newVx = v_temp[0] + dt * F[0] / 2;
			double newVy = v_temp[1] + dt * F[1] / 2;

			// Make sure individuals rebound off the edges of the space
            // TODO: Find a better way of avoiding individuals going out-of-bounds
			if (newX < 0 || newX > maxX) {
				newVx = -newVx;
				F[0] = -F[0];
			}
			if (newY < 0 || newY > maxY) {
				newVy = -newVy;
				F[1] = -F[1];
			}

			// Make sure they don't get stuck in an out-of-bounds area
			if (newX >= 0 && newX <= maxX)
				individual.x = newX;
			if (newY >= 0 && newY <= maxY)
				individual.y = newY;

			individual.vx = newVx;
			individual.vy = newVy;

			// Add the individual to the correct sector
			PositionMatrix.Sector newSector = matrix.getSectorForCoords(individual);
			if (!newSector.equals(initialSector)) {
				matrix.removeAndAdd(individual, initialSector, newSector);
			}
		}
        if (shouldStoreData) {
            writer.print("x = array([");
            boolean firstTime = true;
            for (Individual individual : matrix.getIndividuals()) {
                if (firstTime) writer.print(individual.x);
                else writer.print(", " + individual.x);
                firstTime = false;
            }
            writer.print("\b\b");
            writer.println("])");
            writer.flush();

            writer.print("y = array([");
            firstTime = true;
            for (Individual individual : matrix.getIndividuals()) {
                if (firstTime) writer.print(individual.y);
                else writer.print(", " + individual.y);
                firstTime = false;
            }
            writer.print("\b\b");
            writer.println("])");
            writer.flush();

            writer.print("dangerLevel = array([");
            firstTime = true;
            for (Individual individual : matrix.getIndividuals()) {
                if (firstTime) writer.print(individual.dangerLevel);
                else writer.print(", " + individual.dangerLevel);
                firstTime = false;
            }
            writer.print("\b\b");
            writer.println("])");
            writer.flush();
        }
	}

	private double norm(double[] vector) {
		return Math.sqrt(vector[0] * vector[0] + vector[1] * vector[1]);
	}

	public PositionMatrix getMatrix() {
	    return matrix;
    }

    public Timer getSimulationTimer() {
	    return timer;
    }

    public void performAdditionalCalculations(Individual individual) {

    }
  
}
