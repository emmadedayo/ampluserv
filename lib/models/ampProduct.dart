import 'dart:convert';
class ampProductModel {
  String product_name;
  String id;
  String category;
  String item_weight;
  String sending_region;
  String pickupaddress;
  String receiving_region;
  String deliveryaddress;
  String distance;
  String distance_reduction;
  String duedate;
  String time_due;
  String agent_name;
  String agent_email;
  String agent_phone;
  String agent_accepted;
  String agent_accepted_date;
  String item_delivered;
  String item_delivery_date;
  String delivery_slip;
  String base_charge;
  String distance_charge;
  String weight_charge;
  String tax;
  String delivery_time_charge;
  String delivery_time;
  String total_no_tax;
  String fuel_subcharge_percentage;
  String total_with_fuelsubscharge;
  String discount;
  String agent_earning;
  String grandtotal;
  String image;
  String pickup_vehicle;
  String fuel_subcharge;


  ampProductModel(this.id,this.product_name,this.category,this.item_weight,this.sending_region,this.pickupaddress, this.receiving_region
      ,this.deliveryaddress,this.distance,this.distance_reduction,this.duedate,this.time_due,this.agent_name,this.agent_email
      ,this.agent_phone,this.agent_accepted,this.agent_accepted_date,this.item_delivered,this.item_delivery_date,this.delivery_slip,this.base_charge
      ,this.distance_charge,this.weight_charge,this.tax,this.delivery_time_charge,this.delivery_time,this.total_no_tax,this.fuel_subcharge_percentage
      ,this.total_with_fuelsubscharge,this.discount,this.agent_earning,this.grandtotal,this.image, this.pickup_vehicle, this.fuel_subcharge);


  ampProductModel.fromMap(Map<String, dynamic> map) {
    product_name = map["product_name"];
    id = map["id"];
    category = map["category"];
    item_weight = map["item_weight"];
    sending_region = map["sending_region"];
    pickupaddress = map["pickupaddress"];
    receiving_region = map["receiving_region"];
    deliveryaddress = map["deliveryaddress"];
    distance = map["distance"];
    distance_reduction = map["distance_reduction"];
    duedate = map["duedate"];
    time_due = map["time_due"];
    agent_name = map["agent_name"];
    agent_email = map["agent_email"];
    agent_phone = map["agent_phone"];
    agent_accepted = map["agent_accepted"];
    agent_accepted_date = map["agent_accepted_date"];
    item_delivered = map["item_delivered"];
    item_delivery_date = map["item_delivery_date"];
    delivery_slip = map["delivery_slip"];
    base_charge = map["base_charge"];
    distance_charge = map["distance_charge"];
    weight_charge = map["weight_charge"];
    tax = map["tax"];
    delivery_time_charge = map["delivery_time_charge"];
    delivery_time = map["delivery_time"];
    total_no_tax = map["total_no_tax"];
    fuel_subcharge_percentage = map["fuel_subcharge_percentage"];
    total_with_fuelsubscharge = map["total_with_fuelsubscharge"];
    discount = map["discount"];
    agent_earning = map["agent_earning"];
    grandtotal = map["grandtotal"];
    image = map["image"];
    pickup_vehicle = map["pickup_vehicle"];
    fuel_subcharge = map['fuel_subcharge'];


  }


}
