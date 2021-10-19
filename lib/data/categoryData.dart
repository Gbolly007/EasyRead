import 'package:easy_reads/model/bookCategory.dart';
import 'package:flutter/material.dart';
import '../constant.dart';

List<BookCategories> getCategories(){
  List<BookCategories> bookCategories =[];
  BookCategories categories = new BookCategories();

  categories.icn= AssetImage("images/leadership.png");
  categories.categoryTitle = leadershiptext;
  categories.args = leadershipArgtext;
  categories.clr = kLeadershipClr;
  categories.clr1 = kLeadershipClr1;
  bookCategories.add(categories);
  categories = new BookCategories();

  categories.icn= AssetImage("images/management.png");
  categories.categoryTitle = managementtext;
  categories.args = managementArgText;
  categories.clr = kManagementClr;
  categories.clr1 = kManagementClr1;
  bookCategories.add(categories);
  categories = new BookCategories();

  categories.icn= AssetImage("images/selfdev.png");
  categories.categoryTitle = selfdevtext;
  categories.args = selfdevArgText;
  categories.clr = kPDClr;
  categories.clr1 = kPDClr1;
  bookCategories.add(categories);
  categories = new BookCategories();

  categories.icn= AssetImage("images/marketing.png");
  categories.categoryTitle = marketingtext;
  categories.args = marketingArgtext;
  categories.clr = kMarketingClr;
  categories.clr1 = kMarketingClr1;
  bookCategories.add(categories);
  categories = new BookCategories();

  categories.icn= AssetImage("images/fiction.png");
  categories.categoryTitle = fictiontext;
  categories.args =fictionArgtext;
  categories.clr = kFictionClr;
  categories.clr1 = kFictionClr1;
  bookCategories.add(categories);
  categories = new BookCategories();

  categories.icn= AssetImage("images/sales.png");
  categories.categoryTitle = salestext;
  categories.args = salesArgtext;
  categories.clr = kSalesClr;
  categories.clr1 = kSalesClr1;
  bookCategories.add(categories);
  categories = new BookCategories();

  categories.icn= AssetImage("images/finance.png");
  categories.categoryTitle = financetext;
  categories.args = financeArgtext;
  categories.clr = kFinanceClr;
  categories.clr1 = kFinanceClr1;
  bookCategories.add(categories);
  categories = new BookCategories();


  return bookCategories;

}