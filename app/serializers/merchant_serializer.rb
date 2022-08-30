class MerchantSerializer 
  include JSONAPI::Serializer 
  attributes :name
end

#note to self: serializer gem bypasses the need to handroll all the data hashes for id, type, attributes 

#handrolled would be:
#  def self.format_merchants(merchants)
#    {
#      data: merchants.map do |merchant|
#        {
#          id: merchant.id,
#          type: 'merchant',
#          attributes: {
#             name: merchant.name
#          }
#        }
#      end
#    }
#  end
# end