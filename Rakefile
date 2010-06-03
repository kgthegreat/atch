require File.join(File.dirname(__FILE__), 'config', 'boot')
require 'rake'

import File.join(SPREE_ROOT, 'Rakefile')

namespace :spree do
  desc "Export Products to CSV File"
  task :export_products => :environment do
    require 'fastercsv'

    products = Product.find(:all)
    puts "Exporting to #{RAILS_ROOT}/tmp/products.csv"
    FasterCSV.open("#{RAILS_ROOT}/tmp/products.csv", "w") do |csv|

      csv << ["id", "sku", "name", "description", "price" , "on_hand", "taxons", "has_variants", "no_of_variants", "deleted_at"]

      products.each do |p|
        next if !p.deleted_at.nil?
        csv << [p.id,
                p.sku,
                p.name.titleize,
                p.description,
                p.master_price.to_s,
                p.on_hand,
               # p.taxons[0].name,
         #       p.taxons[0].permalink,
                p.taxons[0].permalink.to_s.reverse.sub('/','').reverse.sub('categories/','').sub('groceries','Groceries').sub('to-be-cooked','To Be Cooked').sub('pulses','Pulses').sub('personal-grooming', 'Personal Grooming').sub('hair-care','Hair Care'),
               # Taxon.find_by_name(p.taxons.permalink),
                p.has_variants?,

#                p.images[0].attachment.path,
#                p.images[0].attachment.url,
                p.variants.size,
                p.deleted_at]


         if p.has_variants?
          p.variants.each do |variant|
            csv << [variant.id,
                    variant.sku,
                    variant.name.titleize,
                    variant.description,
                    variant.price.to_s,
                    variant.on_hand]
          end
        end

      end
    end

    puts "Export Complete"
  end

  desc "Update / Import products from CSV File, expects file=/path/to/import.csv"
  task :import_products => :environment do
    require 'fastercsv'

    n = 0
    u = 0

    FasterCSV.foreach(ENV['file']) do |row|


      if row[0].nil?
        # Adding new product
        puts "Adding new product: #{row[1]}"
        product = Product.new()

        n += 1
      else
        # Updating existing product

        next if row[0].downcase == "id"  #skip header row
        next if row[8].nil?
        next if !row[9].nil?
        puts "Updating product: #{row[1]}"
        product = Product.find(row[0])

        u += 1
      end

      product.available_on =  Time.utc(2000,"jan",1,20,15,1)

      taxonomy = Taxonomy.first          # default to main taxonomy for now
      if row[6].to_s.blank?
        puts "Warning: missing taxon info for #{p.name}"
      else
        taxon = taxonomy.root
        row[6].to_s.gsub('/',',').split(/\s*,\s*/).each do |name|
#        row[6].to_s.split('/').each do |name|

           # nxt = Taxon.find_or_create_by_parent_id_and_taxonomy_id(taxon.id, taxonomy.id)
          nxt = Taxon.find_or_create_by_name_and_parent_id_and_taxonomy_id(name, taxon.id, taxonomy.id)
          #     nxt = Taxon.find_by_name_and_parent_id_and_taxonomy_id(name, taxon.id, taxonomy.id)
            taxon = nxt


         end

#        product.taxons << taxon
        product.taxons = [taxon]
      end

      product.sku = row[1].to_s
      product.name = row[2]
      product.description = row[3]

      product.master_price = row[4].to_d
      # product.on_hand = row[5].to_d
      # product.taxons << Taxon.find_by_name(row[6])
      product.save!

    end

    puts ""
    puts "Import Completed - Added: #{n} | Updated #{u} Products"
   end
end
