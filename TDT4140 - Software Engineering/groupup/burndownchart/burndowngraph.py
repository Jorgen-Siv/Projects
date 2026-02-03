import matplotlib.pyplot as plt

data = open('burndownchart/burndowndata.txt', 'r')
startDate = '9.mar'
sprint3_points = 80
ideelProgresjon = True

def burndowngraph(data, totalPoints, startDate, ideelProgresjon):
    dates = [startDate]
    storyPoints = [totalPoints]

    for i in data:
        if 'date:points' not in i and ':' in i:
            entry = i.split(':')
            date = entry[0]
            points = int(entry[1])
            if date in dates:
                storyPoints[len(storyPoints) - 1] -= points
            else:
                dates.append(date)
                totalPoints = totalPoints - points
                storyPoints.append(totalPoints)
    data.close()

    makegraph(dates, storyPoints, ideelProgresjon)

def makegraph(x, y, ideelProgresjon):
    plt.plot(x, y, '-o', label = 'Faktisk progresjon')
    if ideelProgresjon:
        ideel_y = [y[0], 0]
        plt.plot(x[::len(x) - 1], ideel_y, '-o', color = 'red', label = 'Ideel progresjon')
        plt.legend()

    plt.xlabel('Dates', fontweight = 'bold')
    plt.ylabel('Story Points', fontweight = 'bold')
    plt.title('Brenndiagram', fontweight = 'bold', fontsize = 14)
    plt.gca().yaxis.grid()
    plt.ylim([0, sprint3_points + 10])

    plt.show()


burndowngraph(data, sprint3_points, startDate, ideelProgresjon)