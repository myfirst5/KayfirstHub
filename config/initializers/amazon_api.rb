client = MWS::Orders::Client.new(
    primary_marketplace_id:ENV['MARKETPLACE_ID'],
    merchant_id:           ENV['MERCHANT_ID'],
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)


begin
  response = client.list_orders(created_after: 7.days.ago, order_status: ["Shipped", "PartiallyShipped", "InvoiceUnconfirmed", "Unshipped"])
  # puts response.parse
  response.parse["Orders"]["Order"].each do |order|
     unless Order.exists?(amazon_order_id: order["AmazonOrderId"])
      orderToSave = Order.new
       orderToSave.amazon_order_id = order["AmazonOrderId"]
      orderToSave.purchase_date = order["PurchaseDate"]
      orderToSave.amount = order["OrderTotal"]["Amount"]
       orderToSave.buyer_name = order["BuyerName"]
      orderToSave.save
     end
  end
rescue => e
  puts e.response.message
end

