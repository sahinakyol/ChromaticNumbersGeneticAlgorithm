require 'rubygems'
require 'json'
require 'matrix'

module ProcessorModule
class Process
  def initialize(filename)
    @filename = filename
    @chromosomeHash = chromosomePopulation()
    @fitness = fitness()
    roulette()
    crossover()
  end

  def chromosomeHashSender
    @chromosomeHash
  end

  def readData
   # File.read("./datasets/#{@filename}").split(/[, \n]+/)
   File.read("./datasets/#{@filename}")
  end

  def adjacentVertices
    JSON.parse(readData()) #keys are nodes,  values are adjacent vertices
  end

  def chromosome
    # G => Green , Y => Yellow , B => Blue
    hash ={}
    for i in adjacentVertices().keys.to_a
      hash[i]=['G','Y','B'].sample #coloring
    end
    hash
  end

  def chromosomePopulation
    hash ={}
    for i in 1..5
      hash[['POP1','POP2','POP3','POP4','POP5'].sample] = chromosome()
    end
    hash
  end


  def fitness
    result ={}
       @chromosomeHash.values.each do |hash,key|
         hash.to_a.each_with_index do |value,id|
            if hash.to_a[id].last == hash.to_a[id+1].last
              result[id+1]=value.last
              break
            end
          end
      end
      return result
  end
  def roulette
    @fitness.keys.sort.to_a
  end


  def crossover
    pop = @chromosomeHash.values.to_a
    randNumber = rand pop[0].values.length
    mutation(pop[0].values.first(randNumber) + pop[1].values.last(pop[0].values.length-randNumber))
end


def mutation(chromo)
  2.times { chromo[rand 10] = chromo[rand 2]}
 chromo
end

end
end
