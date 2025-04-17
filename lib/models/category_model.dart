class CategoryModel {
  final String title;
  final String? image, svgSrc;
  final List<CategoryModel>? subCategories;

  CategoryModel({
    required this.title,
    this.image,
    this.svgSrc,
    this.subCategories,
  });
}

final List<CategoryModel> demoCategoriesWithImage = [
  CategoryModel(
      title: "Web Development", image: "https://i.imgur.com/CGCyp1d.png"),
  CategoryModel(
      title: "Mobile Development", image: "https://i.imgur.com/AkzWQuJ.png"),
  CategoryModel(
      title: "UI/UX Design", image: "https://i.imgur.com/J7mGZ12.png"),
  CategoryModel(
      title: "Cloud Solutions", image: "https://i.imgur.com/q9oF9Yq.png"),
];

final List<CategoryModel> demoCategories = [
  CategoryModel(
    title: "Services",
    svgSrc: "assets/icons/Services.svg",
    subCategories: [
      CategoryModel(title: "Web Development"),
      CategoryModel(title: "Mobile Development"),
      CategoryModel(title: "UI/UX Design"),
      CategoryModel(title: "Cloud Solutions"),
      CategoryModel(title: "DevOps"),
    ],
  ),
  CategoryModel(
    title: "Technologies",
    svgSrc: "assets/icons/Technologies.svg",
    subCategories: [
      CategoryModel(title: "Flutter"),
      CategoryModel(title: "React"),
      CategoryModel(title: "Node.js"),
      CategoryModel(title: "Python"),
      CategoryModel(title: "AWS"),
    ],
  ),
  CategoryModel(
    title: "Industries",
    svgSrc: "assets/icons/Industries.svg",
    subCategories: [
      CategoryModel(title: "Healthcare"),
      CategoryModel(title: "Finance"),
      CategoryModel(title: "E-commerce"),
      CategoryModel(title: "Education"),
      CategoryModel(title: "Real Estate"),
    ],
  ),
  CategoryModel(
    title: "Company",
    svgSrc: "assets/icons/Company.svg",
    subCategories: [
      CategoryModel(title: "About Us"),
      CategoryModel(title: "Case Studies"),
      CategoryModel(title: "Blog"),
      CategoryModel(title: "Careers"),
      CategoryModel(title: "Contact"),
    ],
  ),
];
