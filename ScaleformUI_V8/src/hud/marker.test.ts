import {Marker} from "./marker";
import {Rgba} from "../math/rgba";
import {Vector3} from "../math/vector3";

const createMockMarker = (scale?: Vector3, checkZ = true) => new Marker({
    checkZ,
    position: new Vector3(10, 10, 10),
    color: Rgba.white,
    faceCamera: false,
    height: 0,
    rotate: false,
    scale
});

describe("marker test", () => {
    let marker: Marker

    const setupMocks = (coords: [number, number, number]) => {
        const groundZMock = jest.fn(() => [false, 0] as [boolean, number]);
        const ppedMock = jest.fn(() => 0);
        const getEntityCoordsMock = jest.fn(() => coords);
        const drawMarkerMock = jest.fn();

        global.GetGroundZFor_3dCoord = groundZMock;
        global.PlayerPedId = ppedMock;
        global.GetEntityCoords = getEntityCoordsMock;
        global.DrawMarker = drawMarkerMock;

        return { groundZMock, ppedMock, getEntityCoordsMock, drawMarkerMock };
    }

    it("should test marker distance calculations with Z enabled", () => {
        marker = createMockMarker(new Vector3(2, 2, 2));
        const { ppedMock, getEntityCoordsMock } = setupMocks([13, 13, 8]);

        marker.draw();
        expect(marker.isInDrawRange(0, new Vector3(13, 13, 8))).toBeTruthy();
        expect(marker.isPlayerInside()).toBeFalsy();

        expect(ppedMock).toBeCalledTimes(1);
        expect(getEntityCoordsMock).toBeCalledTimes(1);

        setupMocks([10, 11, 10]);

        marker.draw();
        expect(marker.isInDrawRange(0, new Vector3(13, 13, 8))).toBeTruthy();
        expect(marker.isPlayerInside()).toBeTruthy();
    })
    it("should test marker distance calculations with Z disabled", () => {
        marker = createMockMarker(new Vector3(2, 2, 2), false);
        const { ppedMock, getEntityCoordsMock } = setupMocks([13, 13, 8]);

        marker.draw();
        expect(marker.isInDrawRange(0, new Vector3(13, 13, 8))).toBeTruthy();
        expect(marker.isPlayerInside()).toBeFalsy();

        expect(ppedMock).toBeCalledTimes(1);
        expect(getEntityCoordsMock).toBeCalledTimes(1);

        setupMocks([10, 11, 10]);

        marker.draw();
        expect(marker.isInDrawRange(0, new Vector3(13, 13, 50))).toBeTruthy();
        expect(marker.isPlayerInside()).toBeTruthy();
    });
})
