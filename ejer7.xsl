import random
from deap import base, creator, tools, algorithms

# Configurar tipo de problema y individuo
creator.create("FitnessMax", base.Fitness, weights=(1.0,))
creator.create("Individual", list, fitness=creator.FitnessMax)

# Parámetros del algoritmo genético
TAMANO_POBLACION = 10
GENERACIONES = 3
TASA_CRUZAMIENTO = 0.8
TASA_MUTACION = 0.1

# Definir funciones necesarias para DEAP
def crear_individuo():
    return [random.uniform(-10, 10)]

def evaluar_individuo(individuo):
    x = individuo[0]
    return x * 2 * x - 1,

toolbox = base.Toolbox()
toolbox.register("individual", tools.initIterate, creator.Individual, crear_individuo)
toolbox.register("population", tools.initRepeat, list, toolbox.individual)
toolbox.register("evaluate", evaluar_individuo)
toolbox.register("mate", tools.cxBlend, alpha=0.5)
toolbox.register("mutate", tools.mutGaussian, mu=0, sigma=1, indpb=0.1)
toolbox.register("select", tools.selTournament, tournsize=3)

# Algoritmo genético
def algoritmo_genetico_deap():
    poblacion = toolbox.population(n=TAMANO_POBLACION)
    for generacion in range(GENERACIONES):
        # Evaluar
        fitnesses = list(map(toolbox.evaluate, poblacion))
        for ind, fit in zip(poblacion, fitnesses):
            ind.fitness.values = fit
        
        # Selección, cruzamiento y mutación
        offspring = toolbox.select(poblacion, len(poblacion))
        offspring = list(map(toolbox.clone, offspring))

        for child1, child2 in zip(offspring[::2], offspring[1::2]):
            if random.random() < TASA_CRUZAMIENTO:
                toolbox.mate(child1, child2)
                del child1.fitness.values
                del child2.fitness.values

        for mutant in offspring:
            if random.random() < TASA_MUTACION:
                toolbox.mutate(mutant)
                del mutant.fitness.values
        
        poblacion[:] = offspring

        # Re-evaluar la población con individuos modificados
        fitnesses = list(map(toolbox.evaluate, poblacion))
        for ind, fit in zip(poblacion, fitnesses):
            ind.fitness.values = fit

        print(f"Generación {generacion + 1}: {poblacion}")

algoritmo_genetico_deap()
-------------------------------------------------
segunda forma
import random

# Parámetros del algoritmo genético
TAMANO_POBLACION = 10
GENERACIONES = 3
TASA_CRUZAMIENTO = 0.8
TASA_MUTACION = 0.1

# Función de aptitud
def funcion_aptitud(x):
    return x * 2 * x - 1

# Crear individuo aleatorio
def crear_individuo():
    return random.uniform(-10, 10)

# Crear población inicial
def crear_poblacion(tamano):
    return [crear_individuo() for _ in range(tamano)]

# Selección por torneo
def seleccion(poblacion):
    torneo = random.sample(poblacion, 3)
    torneo.sort(key=funcion_aptitud, reverse=True)
    return torneo[0]

# Cruzamiento
def cruzar(padre, madre):
    if random.random() < TASA_CRUZAMIENTO:
        punto_corte = random.randint(1, len(str(padre)) - 1)
        hijo = padre * punto_corte + madre * (1 - punto_corte)
        return hijo
    else:
        return padre

# Mutación
def mutar(individuo):
    if random.random() < TASA_MUTACION:
        mutacion = random.uniform(-1, 1)
        individuo += mutacion
    return individuo

# Algoritmo genético
def algoritmo_genetico():
    poblacion = crear_poblacion(TAMANO_POBLACION)
    for generacion in range(GENERACIONES):
        nueva_poblacion = []
        while len(nueva_poblacion) < TAMANO_POBLACION:
            padre = seleccion(poblacion)
            madre = seleccion(poblacion)
            hijo = cruzar(padre, madre)
            hijo = mutar(hijo)
            nueva_poblacion.append(hijo)
        poblacion = nueva_poblacion
        print(f"Generación {generacion + 1}: {poblacion}")

if __name__ == "__main__":
    algoritmo_genetico()
