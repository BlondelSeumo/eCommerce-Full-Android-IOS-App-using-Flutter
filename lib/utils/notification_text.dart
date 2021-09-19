import '../AppLocalizations.dart';

buildNotificationTitle(status, context) {
  var title = 'Unknown';

  if (status == 'pending') {
    title = AppLocalizations.of(context).translate('title_order_pending');
  } else if (status == 'processing') {
    title = AppLocalizations.of(context).translate('title_order_processing');
  } else if (status == 'on-hold') {
    title = AppLocalizations.of(context).translate('title_order_on_hold');
  } else if (status == 'completed') {
    title = AppLocalizations.of(context).translate('title_order_complete');
  } else if (status == 'cancelled') {
    title = AppLocalizations.of(context).translate('title_order_cancel');
  } else if (status == 'refunded') {
    title = AppLocalizations.of(context).translate('title_order_refund');
  } else if (status == 'failed') {
    title = AppLocalizations.of(context).translate('title_order_failed');
  }

  return title;
}

buildNotificationSubtitle(status, context) {
  var subtitle = 'Unknown';

  if (status == 'pending') {
    subtitle =
        ' ${AppLocalizations.of(context).translate('status_order_pending')}';
  } else if (status == 'processing') {
    subtitle =
        ' ${AppLocalizations.of(context).translate('status_order_processing')}';
  } else if (status == 'on-hold') {
    subtitle =
        ' ${AppLocalizations.of(context).translate('status_order_on_hold')}';
  } else if (status == 'completed') {
    subtitle =
        ' ${AppLocalizations.of(context).translate('status_order_complete')}';
  } else if (status == 'cancelled') {
    subtitle =
        ' ${AppLocalizations.of(context).translate('status_order_cancel')}';
  } else if (status == 'refunded') {
    subtitle =
        ' ${AppLocalizations.of(context).translate('status_order_refund')}';
  } else if (status == 'failed') {
    subtitle =
        ' ${AppLocalizations.of(context).translate('status_order_failed')}';
  }

  return subtitle;
}
