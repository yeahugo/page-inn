class Recommendify::Neighbor

  def initialize(data)
    @data = data
  end

  def item_id
    @data.fetch(:item_id).to_s
  end

  def similarity
    @data.fetch(:similarity)
  end

  def <=>(other)
    other.similarity <=> self.similarity
  end

end