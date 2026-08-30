import '../utils/shared_import.dart';

class PostMediaUploadButton extends StatelessWidget {
  final VoidCallback onTap;

  const PostMediaUploadButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => DottedBorder(
      color: Colors.grey,
      dashPattern: const [6, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.upload,
                color: appStore.isDarkMode ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 8),
              Text(
                languages.lblUMedia,
                style: primaryTextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
}
