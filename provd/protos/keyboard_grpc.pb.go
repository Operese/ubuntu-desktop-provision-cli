// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.3.0
// - protoc             v3.20.3
// source: protos/keyboard.proto

package proto

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
	emptypb "google.golang.org/protobuf/types/known/emptypb"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

const (
	KeyboardService_SetKeyboard_FullMethodName    = "/keyboard.KeyboardService/SetKeyboard"
	KeyboardService_SetInputSource_FullMethodName = "/keyboard.KeyboardService/SetInputSource"
	KeyboardService_GetKeyboard_FullMethodName    = "/keyboard.KeyboardService/GetKeyboard"
)

// KeyboardServiceClient is the client API for KeyboardService service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type KeyboardServiceClient interface {
	SetKeyboard(ctx context.Context, in *SetKeyboardRequest, opts ...grpc.CallOption) (*emptypb.Empty, error)
	SetInputSource(ctx context.Context, in *SetInputSourceRequest, opts ...grpc.CallOption) (*emptypb.Empty, error)
	GetKeyboard(ctx context.Context, in *emptypb.Empty, opts ...grpc.CallOption) (*GetKeyboardResponse, error)
}

type keyboardServiceClient struct {
	cc grpc.ClientConnInterface
}

func NewKeyboardServiceClient(cc grpc.ClientConnInterface) KeyboardServiceClient {
	return &keyboardServiceClient{cc}
}

func (c *keyboardServiceClient) SetKeyboard(ctx context.Context, in *SetKeyboardRequest, opts ...grpc.CallOption) (*emptypb.Empty, error) {
	out := new(emptypb.Empty)
	err := c.cc.Invoke(ctx, KeyboardService_SetKeyboard_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *keyboardServiceClient) SetInputSource(ctx context.Context, in *SetInputSourceRequest, opts ...grpc.CallOption) (*emptypb.Empty, error) {
	out := new(emptypb.Empty)
	err := c.cc.Invoke(ctx, KeyboardService_SetInputSource_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *keyboardServiceClient) GetKeyboard(ctx context.Context, in *emptypb.Empty, opts ...grpc.CallOption) (*GetKeyboardResponse, error) {
	out := new(GetKeyboardResponse)
	err := c.cc.Invoke(ctx, KeyboardService_GetKeyboard_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// KeyboardServiceServer is the server API for KeyboardService service.
// All implementations must embed UnimplementedKeyboardServiceServer
// for forward compatibility
type KeyboardServiceServer interface {
	SetKeyboard(context.Context, *SetKeyboardRequest) (*emptypb.Empty, error)
	SetInputSource(context.Context, *SetInputSourceRequest) (*emptypb.Empty, error)
	GetKeyboard(context.Context, *emptypb.Empty) (*GetKeyboardResponse, error)
	mustEmbedUnimplementedKeyboardServiceServer()
}

// UnimplementedKeyboardServiceServer must be embedded to have forward compatible implementations.
type UnimplementedKeyboardServiceServer struct {
}

func (UnimplementedKeyboardServiceServer) SetKeyboard(context.Context, *SetKeyboardRequest) (*emptypb.Empty, error) {
	return nil, status.Errorf(codes.Unimplemented, "method SetKeyboard not implemented")
}
func (UnimplementedKeyboardServiceServer) SetInputSource(context.Context, *SetInputSourceRequest) (*emptypb.Empty, error) {
	return nil, status.Errorf(codes.Unimplemented, "method SetInputSource not implemented")
}
func (UnimplementedKeyboardServiceServer) GetKeyboard(context.Context, *emptypb.Empty) (*GetKeyboardResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetKeyboard not implemented")
}
func (UnimplementedKeyboardServiceServer) mustEmbedUnimplementedKeyboardServiceServer() {}

// UnsafeKeyboardServiceServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to KeyboardServiceServer will
// result in compilation errors.
type UnsafeKeyboardServiceServer interface {
	mustEmbedUnimplementedKeyboardServiceServer()
}

func RegisterKeyboardServiceServer(s grpc.ServiceRegistrar, srv KeyboardServiceServer) {
	s.RegisterService(&KeyboardService_ServiceDesc, srv)
}

func _KeyboardService_SetKeyboard_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(SetKeyboardRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(KeyboardServiceServer).SetKeyboard(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: KeyboardService_SetKeyboard_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(KeyboardServiceServer).SetKeyboard(ctx, req.(*SetKeyboardRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _KeyboardService_SetInputSource_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(SetInputSourceRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(KeyboardServiceServer).SetInputSource(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: KeyboardService_SetInputSource_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(KeyboardServiceServer).SetInputSource(ctx, req.(*SetInputSourceRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _KeyboardService_GetKeyboard_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(emptypb.Empty)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(KeyboardServiceServer).GetKeyboard(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: KeyboardService_GetKeyboard_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(KeyboardServiceServer).GetKeyboard(ctx, req.(*emptypb.Empty))
	}
	return interceptor(ctx, in, info, handler)
}

// KeyboardService_ServiceDesc is the grpc.ServiceDesc for KeyboardService service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var KeyboardService_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "keyboard.KeyboardService",
	HandlerType: (*KeyboardServiceServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "SetKeyboard",
			Handler:    _KeyboardService_SetKeyboard_Handler,
		},
		{
			MethodName: "SetInputSource",
			Handler:    _KeyboardService_SetInputSource_Handler,
		},
		{
			MethodName: "GetKeyboard",
			Handler:    _KeyboardService_GetKeyboard_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "protos/keyboard.proto",
}
