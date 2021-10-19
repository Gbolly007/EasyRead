import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchService{

  searchByName(String searchField, String searchType){
    if(searchType=="Author"){
      return FirebaseFirestore.instance.collection("books").where("searchKeyAuthor", isEqualTo: searchField.substring(0,1).toUpperCase()).get();
    }
    else{
      return FirebaseFirestore.instance.collection("books").where("searchKeyBooks", isEqualTo: searchField.substring(0,1).toUpperCase()).get();
    }

  }

}