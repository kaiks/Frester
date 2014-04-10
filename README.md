Frester
=======

French vocabulary tester written in AutoIT

![Screenshot](http://kx.shst.pl/frester_b.png)

To use it, compile it and run, or just run as a script.

It's a GUI based tester that let's you memorize things more easily.


CSV file included is used in the following way:

The first line is used as exercise description and will be displayed in the question label box every time. This line also determines whether to vary question and answer (randomly switch between field 1 and field 2)

The lines after exercise description are formatted in the following way:

* field 1
* field 2
* comment

Field 1 and field 2 are used as either a question or an answer: if field 2 is randomly picked as a question, field 1 will be the answer.

Content of the 'comment' field is displayed after the user has decided to check his answer in the lower left region of the window.
