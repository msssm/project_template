import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.util.List;
import java.util.Random;

import javax.swing.Timer;

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
    public int safeDensity = 10;

    /**
     * Density danger level 1
     */
    public int density1 = 20;

    /**
     * Density danger level 2
     */
    public int density2 = 40;

    /**
     * safe Force danger level 
     */
    public int safeForce = 1000;
    /**
     * Force danger level 1
     */
    public int force1 = 3000;
    /**
     * Density danger level 2
     */
    public int force2 = 4000;

    
    public boolean enableForce=true;
    public boolean enableDensity=true;

    public boolean shouldStoreData = false;

    protected PrintWriter writer;

    private double maxX;  // Right-hand border of the terrain
	private double maxY;  // Bottom border of the terrain
	private Timer timer;

	private Random random = new Random(42);
	private int fileCounter = 0;
	private PrintWriter fileCounterWriter;
	private int seedCounter = 0;

	private PositionMatrix matrix;

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
            fileCounterWriter = new PrintWriter("counter.py");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        initializeMatrix();
	}

	private void initializeMatrix() {
		// TODO: Calculate optimal matrix size and sector size
		// for now: create some bogus values
		int tempMatrixSize = 10;

		// The maximum x and y values that an individual can have
		maxX = tempMatrixSize * SECTOR_SIZE;
		maxY = tempMatrixSize * SECTOR_SIZE;

		center = new double[] {maxX / 2, maxY / 2};

        matrix = new PositionMatrix(tempMatrixSize, tempMatrixSize, SECTOR_SIZE);

		for (int i = 0; i < numberOfPeople; i++) {
			// Generate random coordinates
			double[] coords = new double[2];
			coords[0] = random.nextDouble() * SECTOR_SIZE * tempMatrixSize;
			coords[1] = random.nextDouble() * SECTOR_SIZE * tempMatrixSize;

			// Generate random velocity
			double[] velocity = new double[] { random.nextDouble() - 0.5, random.nextDouble() - 0.5 };

			// Decide whether individual is initially participating
			boolean isParticipating = random.nextDouble() < percentParticipating;
			
			//levels of danger, 0 is safe, by default it's safe
			int dangerLevel = 0;

			Individual individual = new Individual(coords, velocity, isParticipating, dangerLevel);

			// Add individual to appropriate sector
			matrix.add(individual);
		}
	}

	public void resetMatrix() {
	    timer.stop();
	    initializeMatrix();
	    window.resetSimulationPanel();
	    window.repaint();
    }

    public void restartSimulation() {
	    timer.stop();
	    initializeMatrix();
	    window.resetSimulationPanel();
	    window.repaint();
	    timer.start();
    }

    public void setSeed(int seed) {
	    random = new Random(seed);
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

	public void runAutomaticSimulation() {
        window = new SimulationGUI(this);

        DataCollector collector = new DataCollector(this, "test", 50, 2000) {
	        @Override
            public void performCustomStuff() {
	            runOneTimestep();
	            window.repaint();
            }
        };
	    timer = new Timer(50, collector);
	    timer.start();
        window.setVisible(true);
    }

	private void runOneTimestep() {

		// List of all the individuals in the matrix
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
			
			individual.dangerLevel = 0;
			// Calculate the danger level
			int numNeighbors = neighbors.size();

			// We use the number of people in the neighbor list to represent density
			if (enableDensity) {
				if (numNeighbors > density2)
					individual.dangerLevel = 3;
				else if (numNeighbors > density1)
					individual.dangerLevel = 2;
				else if (numNeighbors > safeDensity)
					individual.dangerLevel = 1;
				else if (numNeighbors < safeDensity)
					individual.dangerLevel = 0;
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
                    F[0] += -epsilon * ((1 / (distance - 2 * r0)) * (position[0] - positionNeighbor[0])) / distance;
                    F[1] += -epsilon * ((1 / (distance - 2 * r0)) * (position[1] - positionNeighbor[1])) / distance;
                }

				sumOverVelocities[0] += velocityNeighbor[0];
				sumOverVelocities[1] += velocityNeighbor[1];
			}
			
			// Calculate the norm of the force
			double jointForce = norm(F);
		
			if(enableForce) {
				if(jointForce > force2)
					individual.dangerLevel += 3;
				else if(jointForce > force1)
					individual.dangerLevel += 2;
				else if(jointForce > safeForce)
					individual.dangerLevel += 1;
				else if(jointForce < safeForce)
					individual.dangerLevel += 0;
			}

			// Adjust the danger level if only one of the two options is enabled
			if(enableForce ^ enableDensity) {
				individual.dangerLevel*=2;
			}

			// Decide if the individual is participating or not
			if (sumParticipating >= minParticipatingNeighbors) {
				individual.isParticipating = true;
			}

			if (sumParticipating < minCirclePitSize) {
				individual.isParticipating = false;
			}

            if (matrix.isSectorMonitored(matrix.getSectorForCoords(individual))) {
                individual.isParticipating = false;
            }

            // Set preferred speed accordingly
			individual.preferredSpeed = individual.isParticipating ? 30 : 5 * random.nextDouble();

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
			individual.f = norm(F);
			individual.density = neighbors.size();
		}
	}

    /**
     * Writes a small Python/Numpy script to allow analysis of the current situation.
     */
	public void exportData() {
        try {
            writer.close();
            writer = new PrintWriter("special" + fileCounter + ".py", "UTF-8");
        } catch (FileNotFoundException | UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (NullPointerException e) {
            try {
                writer = new PrintWriter("special" + fileCounter + ".py", "UTF-8");
            } catch (FileNotFoundException | UnsupportedEncodingException e1) {
                e1.printStackTrace();
            }
        }
        try {
            fileCounterWriter.close();
            fileCounterWriter = new PrintWriter("special_counter.py");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        writer.println("from numpy import *");
        writer.print("x = array([");
        boolean firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) writer.print(individual.x);
            else writer.print(", " + individual.x);
            firstTime = false;
        }
        writer.println("])");
        writer.flush();

        writer.print("y = array([");
        firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) writer.print(individual.y);
            else writer.print(", " + individual.y);
            firstTime = false;
        }
        writer.println("])");
        writer.flush();

        writer.print("dangerLevel = array([");
        firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) writer.print(individual.dangerLevel);
            else writer.print(", " + individual.dangerLevel);
            firstTime = false;
        }
        writer.println("])");
        writer.flush();

        writer.print("isParticipating = array([");
        firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) writer.print((individual.isParticipating ? 1 : 0));
            else writer.print(", " + (individual.isParticipating ? 1 : 0));
            firstTime = false;
        }
        writer.println("])");
        writer.flush();

        writer.print("F = array([");
        firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) writer.print(individual.f);
            else writer.print(", " + individual.f);
            firstTime = false;
        }
        writer.println("])");
        writer.flush();

        writer.print("density = array([");
        firstTime = true;
        for (Individual individual : matrix.getIndividuals()) {
            if (firstTime) writer.print(individual.density);
            else writer.print(", " + individual.density);
            firstTime = false;
        }
        writer.println("])");
        writer.flush();
        fileCounter++;
        fileCounterWriter.println("n = " + fileCounter);
        fileCounterWriter.flush();
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

    public void setMonitoredSectors(int... sectors) {
        matrix.setMonitoredSectors(sectors);
    }
}
