import '../utils/shared_import.dart';

/// Profile header widget showing the user's avatar, name and profile details
/// with a decorative background layout.
///
/// Developer: Ashika Bhanderi
/// Updated: 2026-03-12 12:21:00
///
/// Reasoning:
/// - Extracted from OtherUserProfileScreen to comply with the 200-line widget rule
/// - Reusable for any user profile header display
class OtherUserProfileHeader extends StatelessWidget {
  final String? profileImage;
  final String firstName;
  final String lastName;

  const OtherUserProfileHeader({
    super.key,
    this.profileImage,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) => Column(
      children: [
        16.height,
        _buildProfileImage()
            .paddingOnly(top: context.height() * 0.11)
            .center(),
        20.height,
        _profileRow(
          label: languages.lblFirstName,
          value: firstName,
        ).paddingSymmetric(horizontal: 8),
        _profileRow(
          label: languages.lblLastName,
          value: lastName,
        ).paddingSymmetric(horizontal: 8),
        15.height,
        _buildPostsDivider(),
      ],
    );

  Widget _buildProfileImage() {
    if (!profileImage.isEmptyOrNull) {
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(
          boxShape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: primaryColor.withValues(alpha: 0.5),
          ),
        ),
        child: cachedImage(
          profileImage,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        ).cornerRadiusWithClipRRect(65),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(
          boxShape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: primaryColor.withValues(alpha: 0.5),
          ),
        ),
        child: const CircleAvatar(
          maxRadius: 60,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(ic_logo),
        ),
      );
    }
  }

  Widget _buildPostsDivider() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        children: [
          const Expanded(
            child: Divider(thickness: 0.7, color: primaryColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              languages.lblPosts,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Expanded(
            child: Divider(thickness: 0.7, color: primaryColor),
          ),
        ],
      ),
    );

  Widget _profileRow({required String label, required String value}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            "$label :",
            style: primaryTextStyle(weight: FontWeight.w700, size: 15),
          ),
        ),
        Expanded(child: Text(value, style: secondaryTextStyle(size: 15))),
      ],
    ),
  );
}
