import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class WebSocketClient{
  Stream<int> getCounterStream();
}

class FakeWebsocketClient implements WebSocketClient{
  @override
  Stream<int> getCounterStream() async* {
    int i = 0;
    while (true){
      await Future.delayed(const Duration(milliseconds: 500));
      yield i++;
    }
  }
}

final websocketClientProvider = Provider<WebSocketClient>((ref){return FakeWebsocketClient();});
final counterProvider = StreamProvider<int>((ref){
  final wsClient = ref.watch(websocketClientProvider);
  return wsClient.getCounterStream();
});
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Riverpod Testing',
     home:HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home')
      ),
      body:Center(
        child: ElevatedButton(
          child: const Text('Go to Counter Page'),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const CounterPage())));
          },
        ),
      ) ,
    );
  }
}

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<int> count = ref.watch(counterProvider);

    ref.listen(
      counterProvider,
      (previous,next){
        if(next==32){
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Warning'),
                content:
                    Text('Counter dangerously high. Consider resetting it.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  )
                ],
              );});
        }
      }
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        actions:[
          IconButton(
            onPressed: (){
             ref.invalidate(counterProvider);
             
            },
             icon: Icon(Icons.refresh),)
        ]
      ),
      body: Center(
        child: Text(
          count.toString(),
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      
    );
  }
}


