atom_feed do |feed|
	feed.title "Who bought #{@product.title}"

	feed.updated @latest_order.try(:updated_at)

	@product.orders.each do |order|
		feed.entry(order) do |entry|
			entry.title "Order #{order.id}"
			entry.summary type: 'xhtml' do |xhtml|
				xhtml.p "Shipped to #{order.address}"

				xhtml.table do
					xhtml.tr do
						xhtml.th 'Product'
						xhtml.th 'Quantity'
						xhtml.th 'Total price'
					end #of tr table

					order.line_items.each do |item|
						xhtml.tr do
							xhtml.td item.product.title
							xhtml.td item.quantity
							xhtml.td number_to_currency item.total_price
						end #of tr item
					end #of item

					xhtml.tr do
						xhtml.th 'total', colspan: 2
						xhtml.th number_to_currency \
							order.line_items.map(&:total_price).sum
					end #of tr					
				end #of table

				xhtml.p "Paid by #{order.pay_type}"
			end #of xhtml

			entry.author do |author|
				author.name order.name
				author.email order.email
			end #of entry author

		end #of entry
	end#of order
end #of atom_feed