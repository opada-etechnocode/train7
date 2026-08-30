import '../utils/shared_import.dart';

class ExerciseCastDeviceList extends StatelessWidget {
  final bool isLoading;
  final ValueChanged<GoogleCastDevice> onDeviceTap;

  const ExerciseCastDeviceList({
    super.key,
    required this.isLoading,
    required this.onDeviceTap,
  });

  @override
  Widget build(BuildContext context) => StreamBuilder<List<GoogleCastDevice>>(
      stream: GoogleCastDiscoveryManager.instance.devicesStream,
      builder: (context, snapshot) {
        final devices = snapshot.data ?? [];

        if (devices.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cast, size: 48, color: Colors.black),
                const SizedBox(height: 10),
                Text(
                  languages.lblNoFoundData,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          itemCount: devices.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final device = devices[index];
            return _buildDeviceItem(context, device);
          },
        );
      },
    );

  Widget _buildDeviceItem(BuildContext context, GoogleCastDevice device) => InkWell(
      onTap: () => onDeviceTap(device),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.05),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildDeviceIcon(),
            const SizedBox(width: 16),
            _buildDeviceInfo(context, device),
            _buildTrailing(context),
          ],
        ),
      ),
    );

  Widget _buildDeviceIcon() => Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.2),
            primaryColor.withValues(alpha: 0.4),
          ],
        ),
        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: const Icon(Icons.cast_connected, size: 28, color: primaryColor),
    );

  Widget _buildDeviceInfo(BuildContext context, GoogleCastDevice device) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.friendlyName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 0.2,
            ),
          ),
          if (device.modelName != null && device.modelName!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                device.modelName!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
        ],
      ),
    );

  Widget _buildTrailing(BuildContext context) => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? const Loader(color: Colors.transparent)
          : Icon(
              Icons.chevron_right,
              size: 24,
              color: primaryColor.withValues(alpha: 0.7),
            ),
    );
}
