require File.join(File.dirname(__FILE__), 'config', 'boot')

# -*- coding: iso-8859-1 -*-

require 'rubygems'
require 'rake'
require 'aws/s3'
require 'csv'
#require 'action_controller/request'
#require 'action_controller/test_process'


import File.join(SPREE_ROOT, 'Rakefile')

namespace :spree do
  desc "Export Products to CSV File"
  task :export_products => :environment do
    require 'fastercsv'

    products = Product.find(:all)
    puts "Exporting to #{RAILS_ROOT}/tmp/products.csv" #some
    def make_pretty_taxon(leaf_taxon,pretty_taxon)
      leaf_taxon_name = leaf_taxon.name
      if leaf_taxon_name == "Groceries" || leaf_taxon_name == "Personal Grooming" || leaf_taxon_name == "Home Care"
        pretty_taxon = leaf_taxon_name + '/' + pretty_taxon;
        return pretty_taxon;
      else
        parent_taxon = Taxon.find(leaf_taxon.parent_id)
        pretty_taxon = parent_taxon.name + "/" + pretty_taxon
        make_pretty_taxon(parent_taxon, pretty_taxon)
      end
    end
    def make_really_pretty_taxon(leaf_taxon,pretty_taxon="")
      pretty_taxon = leaf_taxon.name + '/' + pretty_taxon if !leaf_taxon.nil?
      parent_taxon = Taxon.find(leaf_taxon.parent_id) if !leaf_taxon.nil? && !leaf_taxon.parent_id.nil?
      return pretty_taxon if parent_taxon.name == "Categories"
      make_really_pretty_taxon(parent_taxon,pretty_taxon) if !parent_taxon.nil?
    end
    def check(taxon)

    end
    FasterCSV.open("#{RAILS_ROOT}/tmp/products.csv", "w") do |csv|

      csv << ["id", "sku", "name", "description","measure" ,"price" , "on_hand", "taxons", "has_variants", "no_of_variants", "deleted_at"]#, "taxon_name", "parent", "permalinks", "parent_permalinks", "pretty_taxon", "really_pretty_taxon"]

      products.each do |p|
        next if !p.deleted_at.nil?
        if !p.taxons[0].nil?
          #pretty_taxon = make_pretty_taxon(p.taxons[0],"") + p.taxons[0].name
          really_pretty_taxon = make_really_pretty_taxon(p.taxons[0])
          really_pretty_taxon.chomp!("/")
        end
        csv << [p.id,
                p.sku,
                p.name.titleize,
                p.description,
                nil,                       #this column is for option-types. Master variant does not have any.
                p.master_price.to_s,
                p.on_hand,
                really_pretty_taxon,
                #p.taxons[0].permalink.to_s.reverse.sub('/','').reverse.sub('categories/','').sub('groceries','Groceries').sub('to-be-cooked','To Be Cooked').sub('pulses','Pulses').sub('personal-grooming', 'Personal Grooming').sub('hair-care','Hair Care').sub('skin-care', 'Skin Care').sub('home-care', 'Home Care').sub('bathroom-care', 'Bathroom Care').sub('beverages' , 'Beverages').sub('cold','Cold'),
                p.has_variants?,
                p.variants.size,
                p.deleted_at,
                #p.taxons[0].name,
                #Taxon.find(p.taxons[0].parent_id).name,
                #p.taxons[0].permalink,
                #Taxon.find(p.taxons[0].parent_id).permalink,
                #pretty_taxon,
                #really_pretty_taxon
               ]
                #p.images]


         if p.has_variants?
           puts p.name
           p.variants.each do |variant|
            puts  variant.sku
            if variant.option_values[0].nil?
              measure = nil
            else
              measure =  variant.option_values[0].presentation
            end
            csv << [variant.id,
                    variant.sku,
                    nil,                    #no name and description required for variants
                    nil,
                    measure,
                    variant.price.to_s,
                    variant.on_hand]
          end
        end

      end
    end
    puts "transferring to s3"
    file = "#{RAILS_ROOT}/tmp/products.csv"
    AWS::S3::S3Object.store(file,open(file),'aag-atch')

    puts "Export Complete"
  end

  desc "Update / Import products from CSV File, expects file=/path/to/import.csv"
  task :import_products => :environment do
    require 'fastercsv'

    n = 0
    u = 0

    product_with_variant = nil
    total_variants = nil
 #   list_of_variants = Array.new
    FasterCSV.foreach(ENV['file']) do |row|
      id                = row[0]
      sku               = row[1].to_s.strip
      name              = row[2]
      description       = row[3].to_s.strip
      measure           = row[4].to_s.strip
      price             = row[5].to_s.strip
      on_hand           = row[6].to_s.strip
      taxon_string      = row[7].to_s.strip
      has_variants      = row[8].to_s.strip
      no_of_variants    = row[9].to_s.strip
      deleted_at        = row[10]
      #image_file_name   = row[11]

     # puts total_variants
      if !total_variants.nil? && total_variants > 0 && !product_with_variant.nil?

        if id.nil?
          puts "found a new variant"
          puts sku
          puts price
          if sku.nil? || sku.eql?("")
            sku=product_with_variant.sku
          end
          variant = product_with_variant.variants.create(:sku => sku, :price => price.to_d)
          # variant = product_with_variant.variants.find_or_create_by_sku_and_price(:sku => sku, :price => price.to_d)
          variant.option_values << OptionValue.find_by_presentation(measure)
          variant.on_hand = on_hand.to_i
          variant.save!
        else
          puts "updating a variant"
 #         variant = Product.find(id)
          variant = product_with_variant.variants.find(id)
          variant.sku = sku
          variant.price = price.to_d
          puts "variant on hand #{on_hand.to_i}"
          variant.on_hand = on_hand.to_i
          variant.save!
        end
        total_variants -= 1
        if total_variants ==  0       #if this is the last variant
          product_with_variant.save!  #then save
          total_variants = nil
          product_with_variant = nil
          puts "saved with variants"
        end
        next
     # elsif !total_variants.nil? && total_variants == 0 && !product_with_variant.nil?
      #  next
      end
#=end


      if id.nil? && !name.nil?   # a variant is not a new product. In the csv, the variant does not have the name specified.
        # Adding new product
        puts "Adding new product: #{sku}"
        product = Product.new()

        n += 1
      elsif !id.nil? && !name.nil?
        # Updating existing product

        next if id.downcase == "id"  #skip header row
       # next if row[9].nil?             #this was to skip variants row
     #   next if !deleted_at.nil?            #skip deleted items

        puts "Updating product: #{id}"
        product = Product.find(id)
        puts "Product found: #{product.name}"

        u += 1
      end

      next if name.nil?


      product.available_on =  Time.now
      taxonomy = Taxonomy.first          # default to main taxonomy for now
      if taxon_string.blank?
        puts "Warning: missing taxon info for #{name}"
      else
        taxon_to_store = taxonomy.root
        taxon_string.gsub('/',',').split(/\s*,\s*/).each do |singular_taxon|
          #        row[6].to_s.split('/').each do |name|

          # =>  nxt = Taxon.find_or_create_by_parent_id_and_taxonomy_id(taxon.id, taxonomy.id)
          nxt = Taxon.find_or_create_by_name_and_parent_id_and_taxonomy_id(singular_taxon, taxon_to_store.id, taxonomy.id)
          taxon_to_store = nxt
        end
          #        product.taxons << taxon
        product.taxons = [taxon_to_store]  #assumption: only one taxon for a product
      end

      if sku.nil? || sku.empty?
       # new_sku = rand(9999999) + 1000000;
         product.sku = "SOME"
      else
         product.sku = sku
      end

   #   puts name
      product.name = name
      product.description = description

      product.master_price = price.to_d
      #product.on_hand = on_hand.to_i

#      get("Image File Name").split(',').map(&:strip).each do |file|

=begin
      pick = '/home/kgthegreat/images/amul_ghee.jpg'

      i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, "image/jpg"))
      i.viewable_type = "Product"
      i.viewable = product

      product.images << i #File.open(pick)
      i.save!

      #product.save_image_sizes
=end

=begin
        pick = `find /media/Work/rubyworkspace/atch-development/atch/upload | grep -i "/#{image_file_name}"`.chomp
        puts "Using: ===#{pick}=== from #{image_file_name}"
        if !pick.blank?
          puts "gotpick"
          mime = "image/" + pick.match(/\w+$/).to_s

          i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, mime))
          i.viewable_type = "Product"
          # link main image to the product
          i.viewable = product
          product.images << i
          i.save!

          product.save_image_sizes
        end
=end


=begin
 if has_variants
        puts "Yes we have some variants"
        i = 1
        while i==no_of_variants.to_i
          variant = product.variants.create(:sku => sku, :price => price)
          variant.option_values << OptionValue.find_by_presentation(measure)
        end
      end
=end

      if has_variants.include? "true"
        puts "Yes we have some variants"
        total_variants = no_of_variants.to_i
        product_with_variant = product
        product.save!
      elsif has_variants.include? "false"
        product.save!
      end


    end

    puts ""
    puts "Import Completed - Added: #{n} | Updated #{u} Products"
   end
end
