part of '../home_page.dart';

class _Scaffold extends StatelessWidget with HomeState {
  final Widget nftList;

  const _Scaffold({
    required this.nftList,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "NFT List Searched : ",
              style: AppTextStyle.headline1,
            ),
            Consumer(
              builder: (context, ref, child) {
                int length;
                final nftEntity = nftListAsync(ref);
                if (nftEntity.hasValue) {
                  length = nftEntity.value!.length;
                } else {
                  length = 0;
                }
                return Text(
                  length.toString(),
                  style: AppTextStyle.headline1,
                );
              },
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        nftList,
      ],
    );
  }
}
