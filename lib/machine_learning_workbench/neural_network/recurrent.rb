
module MachineLearningWorkbench::NeuralNetwork
  # Recurrent Neural Network
  class Recurrent < Base

    # Calculate the size of each row in a layer's weight matrix.
    # Each row holds the inputs for the next level: previous level's
    # activations (or inputs), this level's last activations
    # (recursion) and bias.
    # @return [Array<Integer>] per-layer row sizes
    def layer_row_sizes
      @layer_row_sizes ||= struct.each_cons(2).collect do |prev, rec|
        prev + rec + 1
      end
    end

    # Activates a layer of the network.
    # Bit more complex since it has to copy the layer's activation on
    # last input to its own inputs, for recursion.
    # @param i [Integer] the layer to activate, zero-indexed
    def activate_layer nlay #_layer
      # NOTE: current layer index corresponds to index of next state!
      previous = nlay     # index of previous layer (inputs)
      current = nlay + 1  # index of current layer (outputs)
      # Copy the level's last-time activation to the input (previous state)
      # TODO: ranges in `NArray#[]` should be reliable, get rid of loop
      nneurs(current).times do |i| # for each activations to copy
        # Copy output from last-time activation to recurrency in previous state
        @state[previous][0, nneurs(previous) + i] = state[current][0, i]
      end
      act_fn.call state[previous].dot layers[nlay]
    end

  end
end
