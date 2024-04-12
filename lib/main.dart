import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final counterProvider = StateProvider((ref) => 0);
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
    final int count = ref.watch(counterProvider);

    ref.listen<int>(
      counterProvider,
      (previous,next){
        if(next>=5){
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          ref.read(counterProvider.notifier).state++;
        },
        child: const Icon(Icons.add),),
    );
  }
}


