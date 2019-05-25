import 'package:flutter_web_ui/ui.dart';
import 'database_functions.dart';
import 'package:flutter_web/foundation.dart';
import 'package:flutter_web/material.dart';

enum FlavourType{ fruity, floral, sweet, grain, spicy, roast, vegetal, acidity, bitter, body, balance, citrus, malic, tropical, stoneFruit}

class  FlavourDescriptor{

  final Map<String, dynamic> values = new Map<String, dynamic>();

  FlavourType get type => values[DatabaseIds.type];
  set type(FlavourType value) => values[DatabaseIds.type] = value;
  String get name => values[DatabaseIds.name];
  set name(String value) => values[DatabaseIds.name] = value;
  String get description => values[DatabaseIds.description];
  set description(String value) => values[DatabaseIds.description] = value;

  // final String objectId;
  bool isSelected = false;
  bool isQueried = true;
  Color color = Colors.white; 

// Two constructor methods
   FlavourDescriptor({
    @required String nameIn,
    @required String descriptionIn,
    @required dynamic typeIn,
    // this.objectId = Unquiw,
  }){
    assert( nameIn != null);
    assert( descriptionIn != null);
    assert( typeIn != null);
    assert( typeIn is String || typeIn is FlavourType);

    this.name = nameIn;
    this.description = descriptionIn;

    setType(typeIn);
    
    color = getFlavoutTypeColor(typeIn);
  }

  FlavourDescriptor.fromValues(Map < String , dynamic > valuesIn) {
      valuesIn.forEach((key, value){
        if ( key == DatabaseIds.type ) {
          setType(value);
        }
        else{
          values[key] = value;
        }
      });
      color = getFlavoutTypeColor(this.type) ??  Colors.grey;
  } 


  String get typeString {
        
        switch (type) {
    
            case FlavourType.acidity:
            return DatabaseIds.acidity;
            break;
            case FlavourType.balance:
            return DatabaseIds.balance;
            break;
            case FlavourType.bitter:
            return DatabaseIds.bitter;
            break;
            case FlavourType.body:
            return DatabaseIds.body;
            break;
            case FlavourType.floral:
            return DatabaseIds.floral;
            break;
            case FlavourType.fruity:
            return DatabaseIds.fruity;
            break;
            case FlavourType.grain:
            return DatabaseIds.grain;
            break;
            case FlavourType.roast:
            return DatabaseIds.roast;
            break;
            case FlavourType.spicy:
            return DatabaseIds.spicey;
            break;
            case FlavourType.sweet:
            return DatabaseIds.sweet;
            break;
            case FlavourType.vegetal:
            return DatabaseIds.vegetal;
            break;
            case FlavourType.citrus:
            return DatabaseIds.citrus;
            break;
            case FlavourType.malic:
            return DatabaseIds.malic;
            break;
            case FlavourType.tropical:
            return DatabaseIds.tropical;
            case FlavourType.stoneFruit:
            return DatabaseIds.stoneFruit;
            default: throw('No matching statement');
            break;  
          }
        }
    
        FlavourType getTypeFromString(String stringType) {
        
        switch (stringType) {
    
            case DatabaseIds.acidity:
            return FlavourType.acidity;
            break;
            case DatabaseIds.balance:
            return FlavourType.balance;
            break;
            case DatabaseIds.bitter:
            return FlavourType.bitter;
            break;
            case DatabaseIds.body:
            return FlavourType.body;
            break;
            case DatabaseIds.floral:
            return FlavourType.floral;
            break;
            case DatabaseIds.fruity:
            return FlavourType.fruity;
            break;
            case DatabaseIds.grain:
            return FlavourType.grain;
            break;
            case DatabaseIds.roast:
            return FlavourType.roast;
            break;
            case DatabaseIds.spicey:
            return FlavourType.spicy;
            break;
            case DatabaseIds.sweet:
            return FlavourType.sweet;
            break;
            case DatabaseIds.vegetal:
            return FlavourType.vegetal;
            break;
            case DatabaseIds.citrus:
            return FlavourType.citrus;
            break;
            case DatabaseIds.malic:
            return FlavourType.malic;
            break;
            case DatabaseIds.tropical:
            return FlavourType.tropical;
            break;
            case DatabaseIds.stoneFruit:
            return FlavourType.stoneFruit;
            break;
            default: throw('No matching statement');
            break;  
          }
        }
    
    static  Color getFlavoutTypeColor(FlavourType type){
        
        Color color = Colors.white;
    
        switch (type) {
    
            case FlavourType.acidity:
            color = Colors.blueGrey;
            break;
            case FlavourType.balance:
            color = Colors.lightBlue;
            break;
            case FlavourType.bitter:
            color = Colors.grey;
            break;
            case FlavourType.body:
            color = Colors.teal;
            break;
            case FlavourType.floral:
            color = Colors.deepPurple;
            break;
            case FlavourType.fruity:
            color = Colors.indigo;
            break;
            case FlavourType.grain:
            color = Colors.brown;
            break;
            case FlavourType.roast:
            color = Colors.black;
            break;
            case FlavourType.spicy:
            color = Colors.red;
            break;
            case FlavourType.sweet:
            color = Colors.amber;
            break;
            case FlavourType.vegetal:
            color = Colors.lime;
            break;
            case FlavourType.citrus:
            color = Colors.yellow ;
            break;
            case FlavourType.malic:
            color = Colors.green ;
            break;
            case FlavourType.tropical:
            color = Colors .orange;
            break;
            case FlavourType.stoneFruit:
            color = Colors.pink;
            break;
            default: color = Colors.grey;
            break;
            
        }
        return color;
      }

      /// Fruity
    
        static  FlavourDescriptor sharpFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Sharp',
          descriptionIn: 'A sharpness toward the front of the mouth.',
          typeIn: FlavourType.acidity
        );
    
      static  FlavourDescriptor fruityFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Fruity',
          descriptionIn: 'General Taste of fruit.',
          typeIn: FlavourType.fruity
        );
    
        static  FlavourDescriptor lemonyFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Lemon',
          descriptionIn: 'Lemony flavour.',
          typeIn: FlavourType.fruity
        );
    
        static  FlavourDescriptor berryFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Berry',
          descriptionIn: 'Berry-like flavour.',
          typeIn: FlavourType.fruity
        );
    
        /// Acidity
    
         static  FlavourDescriptor sourFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Sour',
          descriptionIn: 'Unpleasant Sour flavour.',
          typeIn: FlavourType.acidity
        );
    
      static  FlavourDescriptor intenseFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Intense',
          descriptionIn: 'Impression of tartness on the back of the tongue..',
          typeIn: FlavourType.acidity
        );
    
        static  FlavourDescriptor dryFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Dry',
          descriptionIn: 'Dry feeling that remains on the back of the tongue after sipping the coffee. From alakaliods within the coffee',
          typeIn: FlavourType.acidity
        );
    
        static  FlavourDescriptor astringentFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Astringent',
          descriptionIn: 'Undesirable level of acidity; sometimes used to refer to an intense briny sensation at the tip of the tongue after sipping the coffee.',
          typeIn: FlavourType.acidity
        );
    
        static  FlavourDescriptor bitterFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Bitter',
          descriptionIn: 'A strong taste or twinge or aftertaste noted on the back of the tongue (one of the four basic tastes detected there). Not to be confused with acidity.',
          typeIn: FlavourType.acidity
        );
    
        static  FlavourDescriptor blandFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Bland',
          descriptionIn: 'Neutral flavor, pale; common in low elevation robusta coffee; also may be due to under-extraction.',
          typeIn: FlavourType.acidity
        );
    
    
        /// Sweet
        static  FlavourDescriptor chocolateFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Chocolate',
          descriptionIn: 'Smooth Cacao flavour',
          typeIn: FlavourType.sweet
        );
    
        static  FlavourDescriptor caramelFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Caramel',
          descriptionIn: 'Smooth sweet camal',
          typeIn: FlavourType.sweet
        );
    
        /// Spicey
    
        static  FlavourDescriptor spiceyFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Spicey',
          descriptionIn: 'Spicey flavour',
          typeIn: FlavourType.spicy
        );
    
        /// Roasty
        
        static  FlavourDescriptor smokyFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Smoky',
          descriptionIn: 'Smoky flavour',
          typeIn: FlavourType.roast
        );
    
        static  FlavourDescriptor roastinessFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Roastiness',
          descriptionIn: 'Roasty flavour',
          typeIn: FlavourType.roast
        );
    
        /// Grain
        
        static  FlavourDescriptor nuttyFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Nutty',
          descriptionIn: 'General nutty flavour',
          typeIn: FlavourType.grain
        );
    
    
        /// Vegetal
        static  FlavourDescriptor herbalFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Herbal',
          descriptionIn: 'Herbal Flavour',
          typeIn: FlavourType.vegetal
        );
        
    
        static  FlavourDescriptor complexFlavourDescriptor = FlavourDescriptor(
          nameIn: 'Complex',
          descriptionIn: 'Having lots of elements and diamensions to the favour profile',
          typeIn: FlavourType.balance
        );
    
        static List<FlavourDescriptor> flavours = <FlavourDescriptor>[
            FlavourDescriptor.sharpFlavourDescriptor,
            FlavourDescriptor.fruityFlavourDescriptor,
            FlavourDescriptor.lemonyFlavourDescriptor,
            FlavourDescriptor.berryFlavourDescriptor,
            FlavourDescriptor.sourFlavourDescriptor,
            FlavourDescriptor.intenseFlavourDescriptor,
            FlavourDescriptor.dryFlavourDescriptor,
            FlavourDescriptor.astringentFlavourDescriptor,
            FlavourDescriptor.bitterFlavourDescriptor,
            FlavourDescriptor.blandFlavourDescriptor,
            FlavourDescriptor.chocolateFlavourDescriptor,
            FlavourDescriptor.caramelFlavourDescriptor,
            FlavourDescriptor.spiceyFlavourDescriptor,
            FlavourDescriptor.smokyFlavourDescriptor,
            FlavourDescriptor.roastinessFlavourDescriptor,
            FlavourDescriptor.nuttyFlavourDescriptor,
            FlavourDescriptor.herbalFlavourDescriptor,
            FlavourDescriptor.complexFlavourDescriptor,
      
      ];
    
      void setType(dynamic typeIn) {
        assert( typeIn is String || typeIn is FlavourType);

        if (typeIn is FlavourType){
          type = typeIn;
        }
        else{
          type = getTypeFromString(typeIn);
        }
      }
}
    
    // complex








// BODY—Describes the “mouthfeel” of the coffee as it settles on your tongue, its tactile impression or weight and consistency as perceived in the mouth; the coffee’s heaviness or viscosity (thickness), which contributes to a sensation of the coffee’s richness, its flavor and aroma.

// Extracted oils resulting from the brewing process also contribute to the body. French Presses and espressos have more body due to the brewing method, while drip/filter machines remove desirable flavor oils resulting in a coffee with a lighter body.  A coffee’s body may be light or thin, medium, full, or very full (e.g., buttery or syrupy). A fuller-bodied gourmet coffee retains more flavor when diluted.

// BOUQUET—The coffee’s fragrant aroma and aftertaste, sometimes referred to as the gourmet coffee’s “nose.”

// BRIGHT—A pleasant amount of acidity in a coffee; sharp acidity; tangy; leaves a dry aftertaste.

// BRINY—A salty feeling/sensation in the mouth after drinking coffee that has been over-brewed or exposed to excessive heat after brewing.

// BUTTERY—Rich and oily sensation/flavor produced by flavor oils in the coffee; may resemble the smooth richness of butter; often found in fuller-bodied gourmet coffees. This buttery sensation is more pronounced when the method used to brew the coffee is one that allows more oils to extract into the coffee.

// Premium gourmet coffee that is brewed with a French Press will have more oil than a drip/filter because paper filters tend to remove the coffee’s oils.

// CARAMELLY—Sweet taste/aromatic sensation caused by the coffee’s sugar compounds producing flavors suggestive of syrupy candy—caramel-like.

// CARBONY—A roasty aroma common in dark roasted coffees; burnt (charcoal) smell/flavor.

// CHOCOLATY—Sweet, roasty aroma and/or aromatic aftertaste reminiscent of unsweetened chocolate, cocoa, or vanilla.

// CINNAMON—Spicy cinnamon aroma.

// CLEAN—Finishes clear, smooth, and gracefully in the mouth; not dry; pure flavor, no changes or twists in the mouth or different after-taste.

// COCOA—Aroma reminiscent of unsweetened chocolate; bittersweet.

// COMPLEX—Many layers of taste sensations amongst the flavors.

// DIRTY—Grimy (different than musty or earthy).

// DRY—A particular type of acidity; when a coffee’s finish gives a parched or dehydrated sensation in the mouth; bright. Opposite of clean and sweet. Often present in light/delicate gourmet coffees.

// DRY-PROCESSED—Coffee that is dry-processed is dried in the sun and then raked free of the dried fruit.  When the coffee is bagged there may be fruit remnants along with the beans, and thus dry-processed coffees will have more body though they may lack the “snap” or acidity of wet-processed coffees.

// EARTHY—Musty taste or aroma, like moist black earth or soil, cellar-like, mushroomy. May or may not be desirable. Indonesian gourmet coffees typically have a spicy, earthy flavor.

// FINE—Describes a premium gourmet coffee with a good balance of body and acidity along with its other positive characteristics.

// FINISH—Refers to the sensation remaining on the palette after the coffee is swallowed or spit out (as a “cupper” will do after tasting the coffee).  The coffee’s aftertaste may be quick or lingering, dry and light and crisp, or sweet and heavy.


// FLAT—Describes a coffee with no acidity, lackluster, boring and dull.

// FLAVOR—An overall perception and description of the coffee’s distinctive characteristics including Aroma, Acidity, and Body—in essence, flavor is the fusion of these qualities.

// FLORAL—Very pleasant flavor and/or aroma.  Said to be reminiscent of flower blossoms.

// FRAGRANT—Substantial aroma—may be floral, spicy, etc.

// FRESH—Describes a gourmet coffee with a vibrant aroma; freshly roasted.

// FRUITY—Aroma or flavor reminiscent of various fruits including berries, cherries, citrus, currants, etc.; sweet or tangy. Generally a desirable flavor characteristic. Always accompanied by some degree of acidity, which is usually positive though may indicate over-fermentation (over ripeness). Often found in Arabica premium gourmet coffees.

// GRASSY—Aroma and/or taste suggestive of grass or alfalfa; herbaceous.

// HARSH—An unpleasant bitter or offensive taste; raspy, caustic; often compared to raw weeds—generally undesirable though some people prefer a hint of it in a blend. Most common in Robusta coffees.

// HERBAL—Suggestive of dried herbs, grass, perhaps dry beans. Herbaceous flavor or aroma.

// FULL—A gourmet coffee that excels in the major characteristics of body, acidity, and flavor; strong character.

// LIGHT—Delicate body, acidity and aroma, a coffee with a mild character.

// LIVELY—Pleasing acidity; vibrant.

// MELLOW—Full and well-balanced; the gourmet coffee’s finish is delicate and mild, and lacks significant acidity (low to medium), but is not flat.

// MILD—A gourmet coffee with moderate body and a balanced sweetness and acidity. The finish lacks dryness and bitterness.

// MUDDY—Flat and thick.

// MUSTY—Cellared aroma, stuffy; may be positive attribute if the gourmet coffee was aged properly.

// NEUTRAL—Very low acidity; bland; implying no off-tastes which can make it good for blending; describes many Brazilian Arabicas.

// NUTTY—A distinct flavor/aromatic taste sensation suggestive of roasted nuts (e.g., almonds, peanuts, hazelnuts, etc.).

// PUNGENT—Piercing sensation in mouth, strong characteristic, common in many full-bodied premium gourmet coffees.

// RANCID—Sour offensive flavor of coffee stored improperly.

// RICH—Pleasingly full-bodied gourmet coffee with deep, complex flavors and finish.

// ROASTY—Desirably smoky flavor of a high quality gourmet coffee that has been properly dark roasted.

// RUBBERY—Burnt rubber smell.

// SCORCHED—Improperly roasted or brewed coffee, likely subjected to too much heat, and possibly resulting in an acrid and bitter aroma.

// SMOKY—Desirably roasty flavor of a premium gourmet coffee that has been properly dark roasted.

// SMOOTH—A quality resulting from low acidity.

// STALE—A one-dimensional flavor, flat (e.g., cardboard); the result of improper storage of the coffee.

// SOUR—Undesirable level of acidity; sharp, tart taste detected toward the back of the tongue on the sides, or an intense briny sensation on the tip of the tongue; sometimes compared to the taste of unripe fruit; may be present in light roasted coffees, and it is sometimes associated with over-fermented coffee.

// SPICY—A savory or sweet character with a flavor and/or fragrant exotic aroma reminiscent of spices like allspice, clove and cinnamon. Common in Guatemalan coffees and Indonesian coffees.

// STALE—Flat, cardboard taste—the result of coffee being overexposed to oxygen.

// STRAWY—Undesirable flavor or aroma reminiscent of hay.

// STRONG—Full bodied, rich.

// SWEET—Smooth and mild; palatable; free of harsh flavors and defects; perhaps fruity taste sensed on the tip of the tongue; lack of harshness.

// SYRUPY—Heavy mouthfeel; thick and sweet; sticky.

// TANGY—Piercing and intense sweet and sour sensation on the sides of the tongue.

// TONE—The coffee’s color and appearance.

// TURPENY—Turpentine-like flavor.

// WATERY—Lacks body.

// WEAK—Coffee with light body, but not flat.

// WET-PROCESSED—Coffee that is wet-processed is known as washed coffee because it has been washed of any dust and dirt as well as fruit that was left on the beans.  The wet process is said to make coffee taste “clean” in the cup with an acidity that shines through with brightness.  The only problem with wet-processing is that the coffee loses much of its body. (See Dry-Processed.)

// WILD—Gamey; usually but not always considered undesirable.

// WINY (WINEY)– A hint of a taste sensation reminiscent of fine, mature red wine; rich, fruity essence; a flavor quality which derives from the contrast between a smooth body and a fruit-like acidity. Kenyan gourmet coffees commonly exhibit this attribute, as do the syrupy-bodied Sumatra gourmet coffees and the Harrar premium coffees with their snappy, acidy flavor.

// WOODY—Floral aroma suggestive of oak or tree bark; the result of proper aging of gourmet coffee.
// Aromas
// Animal-like 
// This odour descriptor is somewhat reminiscent of the smell of animals.  It is not a fragrant aroma like musk but has the characteristic odour of wet fur, sweat, leather, hides or urine.  It is not necessarily considered as a negative attribute but is generally used to describe strong notes.

// Ashy 
// This odour descriptor is similar to that of an ashtray, the odour of smokers' fingers or the smell one gets when cleaning out a fireplace.  It is not used as a negative attribute.  Generally speaking this descriptor is used by the tasters to indicate the degree of roast.

// Burnt/Smokey 
// This odour and flavour descriptor is similar to that found in burnt food.  The odour is associated with smoke produced when burning wood.  This descriptor is frequently used to indicate the degree of roast commonly found by tasters in dark-roasted or oven-roasted coffees.

// Chemical/Medicinal 
// This odour descriptor is reminiscent of chemicals, medicines and the smell of hospitals.  This term is used to describe coffees having aromas such as rio flavour, chemical residues or highly aromatic coffees which produce large amounts of volatiles.

// Chocolate-like 
// This aroma descriptor is reminiscent of the aroma and flavour of cocoa powder and chocolate (including dark chocolate and milk chocolate).  It is an aroma that is sometimes referred to as sweet.

// Caramel 
// This aroma descriptor is reminiscent of the odour and flavour produced when caramelizing sugar without burning it.  Tasters should be cautioned not to use this attribute to describe a burning note.

// Cereal/Malty/Toast-like 
// This descriptor includes aromas characteristic of cereal, malt and toast.  It includes scents such as the aroma and flavour of uncooked or roasted grain (including roasted corn, barley or wheat), malt extract and the aroma and flavour of freshly baked bread and freshly made toast.  This descriptor has a common denominator, a grain-type aroma.  The aromas in this descriptor were grouped together since tasters used these terms interchangeably when evaluating standards of each one.

// Earthy 
// The characteristic odour of fresh earth, wet soil or humus.  Sometimes associated with moulds and reminiscent of raw potato flavour, considered as an undesirable flavour when perceived in coffee.

// Floral 
// This aroma descriptor is similar to the fragrance of flowers.  It is associated with the slight scent of different types of flowers including honeysuckle, jasmine, dandelion and nettles.  It is mainly found when an intense fruity or green aroma is perceived but rarely found having a high intensity by itself.

// Fruity/Citrus 
// This aroma is reminiscent of the odour and taste of fruit.  The natural aroma of berries is highly associated with this attribute.  The perception of high acidity in some coffees is correlated with the citrus characteristic.  Tasters should be cautioned not to use this attribute to describe the aroma of unripe or overripe fruit.

// Grassy/Green/Herbal 
// This aroma descriptor includes three terms which are associated with odours reminiscent of a freshly mowed lawn, fresh green grass or herbs, green foliage, green beans or unripe fruit.

// Nutty 
// This aroma is reminiscent of the odour and flavour of fresh nuts (distinct from rancid nuts) and not of bitter almonds.

// Rancid/Rotten 
// This aroma descriptor includes two terms which are associated with odours reminiscent of deterioration and oxidation of several products.  Rancid as the main indicator of fat oxidation mainly refers to rancid nuts and rotten is used as an indicator of deteriorated vegetables or non-oily products.  Tasters should be cautioned not to apply these descriptors to coffees that have strong notes but no signs of deterioration.

// Rubber-like 
// This odour descriptor is characteristic of the smell of hot tyres, rubber bands and rubber stoppers.  It is not considered a negative attribute but has a characteristic strong note highly recognisable in some coffees.

// Spicy 
// This aroma descriptor is typical of the odour of sweet spices such as cloves, cinnamon and allspice.  Tasters are cautioned not to use this term to describe the aroma of savoury spices such as pepper, oregano and Indian spices.

// Tobacco 
// This aroma descriptor is reminiscent of the odour and taste of tobacco but should not be used for burnt tobacco.

// Winey 
// This terms is used to describe the combined sensation of smell, taste and mouthfeel experiences when drinking wine.  It is generally perceived when a strong acidic or fruity note is found.  Tasters should be cautioned not to apply this term to a sour or fermented flavour.

// Woody 
// This aroma descriptor is reminiscent of the smell of dry wood, an oak barrel, dead wood or cardboard paper.

// Tastes
// Acidity 
// A basic taste characterised by the solution of an organic acid.  A desirable sharp and pleasing taste particularly strong with certain origins as opposed to an over-fermented sour taste.

// Bitterness 
// A primary taste characterised by the solution of caffeine, quinine and certain alkaloids.  This taste is considered desirable up to a certain level and is affected by the degree of roast brewing procedures.

// Sweetness 
// This is a basic taste descriptor characterised by solutions of sucrose or fructose which are commonly associated with sweet aroma descriptors such as fruity, chocolate and caramel.  It is generally used for describing coffees which are free from off-flavours

// Saltiness 
// A primary taste characterised by a solution of sodium chloride or other salts.

// Sourness 
// This basic taste descriptor refers to an excessively sharp, biting and unpleasant flavour (such as vinegar or acetic acid).  It is sometimes associated with the aroma of fermented coffee.  Tasters should be cautious not to confuse this term with acidity which is generally considered a pleasant and desirable taste in coffee.

// Mouthfeel
// Body 
// This attribute descriptor is used to describe the physical properties of the beverage.  A strong but pleasant full mouthfeel characteristic as opposed to being thin.

// Astringency 
// This attribute is characteristic of an after-taste sensation consistent with a dry feeling in the mouth, undesirable in coffee.
// }

