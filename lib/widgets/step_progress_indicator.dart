import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;

  const StepProgressIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const steps = ['General Information', 'Customization', 'Advanced settings'];

    return ConstrainedBox(constraints: BoxConstraints(maxWidth: 900),child: Column(
      //mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            final stepNum = index + 1;
            final isActive = currentStep == stepNum;
            final isCompleted = currentStep > stepNum;

            return Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // if (index != 0)
                    //   Expanded(
                    //     child: Container(
                    //       height: 2,
                    //       color: isCompleted ? Colors.deepPurple : Colors.grey[300],
                    //     ),
                    //   ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive || isCompleted ? Colors.deepPurple : Colors.grey,
                          width: 2,
                        ),
                        color: isCompleted ? Colors.deepPurple : Colors.white,
                      ),
                      child: Icon(
                        isCompleted
                            ? Icons.check
                            : isActive
                            ? Icons.edit
                            : Icons.circle_outlined,
                        color: isCompleted || isActive ? Colors.blue : Colors.grey,
                        size: 16,
                      ),
                    ),
                    if (index != steps.length-1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: currentStep > stepNum ? Colors.deepPurple : Colors.grey[300],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  steps[index],
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.deepPurple : Colors.black,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ));
          }),
        )
      ],
    ),);
  }
}
