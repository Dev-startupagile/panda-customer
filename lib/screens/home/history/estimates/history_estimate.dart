import 'package:flutter/material.dart';

class HistoryEstimates extends StatelessWidget {
  const HistoryEstimates({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(),
        child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 70),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Image.asset(
                          "assets/car.png",
                          width: 40,
                          height: 40,
                        ),
                        title: const Text("White Honda Acc .."),
                        subtitle: const Text("2008 Honda Accord"),
                        trailing: const Text(
                          "\$150.00",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Change Battery",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Service includes battery changeout and fluid check.",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black54,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                            child: const Text(
                              'VIEW ESTIMATE',
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                            child: const Text(
                              'SCHEDULE REPAIR',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Expired",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  color: Colors.grey[80],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(
                        width: 2,
                        color: Colors.transparent,
                      )),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Image.asset(
                            "assets/car.png",
                            width: 40,
                            height: 40,
                          ),
                          title: const Text("White Honda Acc .."),
                          subtitle: const Text("2008 Honda Accord"),
                          trailing: const Text(
                            "\$150.00",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "New House",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Rubber hose connected to fuel lines is leaking and needs to be replaced.",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black54,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          child: const Text(
                            'VIEW ESTIMATE',
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Center(child: Text("Load More")),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    ));
  }
}
